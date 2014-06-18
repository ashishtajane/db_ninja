class ProjectsController < ApplicationController

  before_action :get_instance_variables ,only: [:show , :update , :edit ,:destroy,:submit_query, :query_div,:constraints_load,:load_function_field_div,:report_query]
  before_action :check_collaborator,only: [:show , :update , :edit]
  #before_action :owner_of_the_project, only: [:show]

  def new
    @project = Project.new()
  end

  def create
    @project = Project.new( project_params)
    @project[:user_id] = current_user.id
    if @project.save
      Collaboration.create(:project_id => @project.id , :user_id => current_user.id)
      flash[:success]  = "project Added"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @project=Project.find(params[:id].to_i)
  end

  def update
  end
  
  def edit
  end

  def destroy
    @project.destroy
    redirect_to root_url
  end

  def submit_query
  end

  def report_query
    param = params.sort_by {|x,y| x}

    separate_where =[]

    param.each do
      |x,y|
      if x.include? "selection" and y =="where"
        separate_where.push(x.split("_")[1])
      end
    end

    entity_map = get_entity_map(param)
    field_map = get_field_map(param,entity_map)
    group_map = get_groups(field_map)
    constraints = get_constraints(group_map,param)
    @value = {}
    @where_clause = ""
    @select_clause = params["function"] + "(" + params["function_entity"]+"."+params["function_field"]+")"
    arr = entity_map.map { |x,y| y}.uniq
    unless arr.include? params["function_entity"]
      flash.now[:error] = "Model Name selected should occur in grouping"
      render 'submit_query'
    end
    @from_clause = arr.join(",")

    array_for_grouping = []
    group_map.each { 
      |x,y| 
      flag=false
      y.each do
        |str|
        unless separate_where.include? str.split("_")[0]
          flag=true
        end
      end
      if flag 
        array_for_grouping.push(x[0]+"."+x[1])
      end
    }
    
    @group_clause = array_for_grouping.uniq.join(",")

    constraints.each do
      |x,y|
      z=""
      y.each do
        |s|
        if( z== "")
          z = z+get_constraint_string(x[0]+"."+x[1],s.to_a,s.length-1)
        else
          z = z+" and "+get_constraint_string(x[0]+"."+x[1],s.to_a,s.length-1)
        end
      end
      @value[x] = z
      if @where_clause == ""
        @where_clause = @where_clause + z
      else
        @where_clause = @where_clause + " and " +z
      end
    end
    if @group_clause != ""
      @select_clause = @group_clause + "," + @select_clause
    end
    @query_to_be_fired = "select " + @select_clause + " from " + @from_clause 
    if @where_clause != ""
      @query_to_be_fired = @query_to_be_fired + " where " + @where_clause
    end
    if @group_clause != ""
      @query_to_be_fired = @query_to_be_fired + " group by " + @group_clause
    end
  end

  def query_div
    @entity = @project.entities.find(params["entity_selected"].to_i)
    @fields = @entity.fields
    @counter = params["entity_counter"]
    # @field_counter = params["field_counter"]
    #debugger
    respond_to do |format|
      format.js {}
    end
  end

  def constraints_load
    
    @field = Field.find(params["field_selected"].to_i)
    @entity_counter = params["entity_counter"]
    @field_counter  = params["field_counter"]

    respond_to do |format|
      format.js {}
    end
  end

  def load_function_field_div 
    @entity = @project.entities.find(params["entity_selected"].to_i)
    @fields = @entity.fields
    respond_to do |format|
      format.js {}
    end
  end

  def arguments_load
    @constraint = Constraint.find(params["constraint_selected"])
    @function = FunctionReturnType.find(@constraint.function_return_type_id);
    @argument = @constraint.arguments
    @entity_counter = params["entity_counter"]
    @field_counter = params["field_counter"]
    @constraint_counter = params["constraint_counter"]
    @return_type = params["return_value_above"]
    respond_to do |format|
      format.js{}
    end
  end

  private

    def project_params
      params.require(:project).permit(:name,:description, :host, :dbusername,:dbpassword,:adapter,:dbname)
    end

    def get_instance_variables
      @project = Project.find(params[:id])
      @owner = @project.user
    end

    def get_constraint_string(variable,a,size)
      if(size<0)
        return variable
      end
      if ( a[size][0] == "")
        return ""
      end
      id = a[size][0].to_i
      arguments = a[size][1]
      cons = Constraint.find(id)
      if (cons.function_type == -1)
        return_string =  get_constraint_string(variable,a,size-1) + " " + cons.sql_syntax + " " + arguments[0]
        return return_string
      else
        var=""
        unless arguments == nil
          arguments.each do
            |arg|
            var = var + "," + arg.to_s
          end
        end
        return_string =  cons.sql_syntax + "(" +get_constraint_string(variable,a,size-1) + var + ")"
        return return_string
      end
    end

    def get_entity_map(params)
      entity_map={}
      params.each do
        |x,y|
        if x.include? "entity_name"
          entity_map[x.split("_")[2]]=y
        end
      end
      return entity_map
    end

    def get_field_map(param,entity_map)
      field_map = {}
      param.each do
        |x,y|
        if y==""
          next
        end
        if x.include? "property_name"
          a=[]
          x=x.split("_")
          a.push (entity_map[x[2]])
          x= x[2]+ "_" +x[3]
          a.push(y)
          field_map[x] = a
        end
      end
      return field_map
    end

    def get_groups(field_map)
      group_map = {}
      field_map.each do
        |x,y|
        if group_map.has_key?(y)
          group_map[y].push(x)
        else
          group_map[y]= []
          group_map[y].push(x)
        end
            end
      return group_map
    end

    def get_constraints_from_a_b(param, s)
      con = {}
      arg = {}
      arr = {}
      param.each do
        |x,y|
        if x.include? ("constraint_"+s)
          con [x.split("_")[3]] = y
        end
        if x.include? "argument_"+s
          unless arg.has_key? x.split("_")[3]
            arg[x.split("_")[3]]=[]
          end
          arg[x.split("_")[3]].push(y)
        end
      end
      con.each do
        |x,y|
        arr[y] = arg[x]
      end
      return arr
    end

    def get_constraints(group_map,param)
      constraints = {}
      group_map.each do
        |x,y|
        unless constraints.has_key? x
          constraints[x] = []
        end
        y.each do
          |str|
          constraints[x].push(get_constraints_from_a_b(param,str))
          #puts str,constraints[x],str
        end
      end
      return constraints
    end

  # def owner_of_the_project
  #   @collaborating_users = Project.find(params[:id]).collaborating_users
  #   unless @collaborating_users.include? current_user
  #     flash[:error] = "You are not the collaborator for this project"
  #     redirect_to root_url
  #   end
  # end

end
