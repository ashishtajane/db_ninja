class ProjectsController < ApplicationController
  before_action :get_instance_variables ,only: [:show , :update , :edit ,:destroy,:submit_query, :query_div,:constraints_load,:load_function_field_div,:report_query]
  before_action :check_collaborator,only: [:show , :update , :edit,:submit_query]

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
    @joining_params = []
    @all_entities = @project.entities
    @all_entities.each do
      |entity|
      fields = entity.fields
      fields.each do
        |field|
        a={}
        a["name"] = (entity.model_name.to_s + " <=> ")+field.name.to_s
        a["value"] = (entity.table_name.to_s + " <=> ")+field.name.to_s
        @joining_params.push(a)
      end
    end
  end

  def report_query
    @header = []
    @actual_header = []
    if ( params["coming_from_submit_query"] =="1")
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

      @extra_select_params = get_extra_select(param)

      @select_clause = @extra_select_params.join(',')

      @header = @extra_select_params

      if( @select_clause != "" )
        @select_clause = @select_clause + ","
      else
        @select_clause = ""
      end

      @select_clause = @select_clause +  params["function"] + "(" + params["function_entity"]+"."+params["function_field"]+")" 


      from_c,where_c = get_from_where ( param )

      arr = (from_c + entity_map.map { |x,y| y}).uniq

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
      @header =  array_for_grouping + @header 
      @actual_header = @header

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

      if @where_clause == ""
        @where_clause = where_c.join(' and ')
      else
        @where_clause = ( @where_clause + ' and ') + where_c.join(' and ')
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
      @dbname = @project.dbname
      @dbusername = @project.dbusername
      @dbpassword = params[:dbpassword]
      @host = @project.host
      query = @query_to_be_fired

      if @host.include? ':'
        command = "mysql -h " + @host.split(':')[0] + " -p " + @host.split(':')[1] + "-D "+@dbname+" -u " + @dbusername + " -p"+@dbpassword+" -e " + "\""+query+"\""
      else
        #command = "mysql -h " + @host +  "-D "+@dbname+" -u " + @dbusername + " -p"+@dbpassword+" -e " + "\""+query+"\""
        command = "mysql -h " + " localhost " +  "-D "+@dbname+" -u " + @dbusername + " -p"+@dbpassword+" -e " + "\""+query+"\""
      end
      

      value = `#{command}`
      @ashish = command
      @making_graph = []
      if value != ""
        answer = value.split("\n")
        answer = answer[1,answer.size-1]
        answer.each_index do |i|
          answer[i] = answer[i].split("\t")
          push_value = answer[i][0,answer[i].size-1]
          v= []
          v.push(push_value)
          v.push ( answer[i][answer[i].size-1] )
          @making_graph.push(v)
        end
      end
      @actual_graph = @making_graph

    elsif (params["coming_from_submit_query"] =="2")
      @actual_graph = get_array_form(params["actual_graph"])
      @making_graph = @actual_graph
      @actual_header = get_header(params["actual_header"])
      @header = @actual_header

    elsif (params["coming_from_submit_query"] =="3")
      @actual_graph = get_array_form(params["actual_graph"])
      @actual_header = get_header(params["actual_header"])
      @making_graph = get_array_form(params["making_graph"])
      @header = get_header(params["header"])

      @minus_header = []
      @index_header = []
      
      params.each do |p,q|
        if p.include? "graph_group_"
          @minus_header.push(@header[q.to_i])
          @index_header.push(q.to_i)
        end
      end
      if (@index_header.size!=0 and params["fun_graph"] != "" )
        @header =  @minus_header
        @making_graph = find_new_graph(@index_header, @making_graph,params["fun_graph"])
      end
    else
      answer = get_array_form(params["making_graph"])
      @actual_graph = get_array_form(params["actual_graph"])
      @actual_header = get_header(params["actual_header"])
      @header = get_header(params["header"])
      if ( params.include? "operation")
        @making_graph = find_query(params["operation"],params["graph_argument_1"],params["graph_argument_2"],answer)
      end
    end
  end


  def query_div
    @entity = @project.entities.find(params["entity_selected"].to_i)
    @fields = @entity.fields
    @counter = params["entity_counter"]
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

    def find_query(operation,input1,input2,arr)
      answer = []
      arr.each do |x|
        if( operation == "1" )
          if( x[1].to_i > input1.to_i)
            answer.push(x)
          end
        end
        if( operation == "2" )
          if( x[1].to_i < input1.to_i)
            answer.push(x)
          end
        end
        if( operation == "3" )
          if( x[1].to_i > input1.to_i && x[1].to_i < input2.to_i)
            answer.push(x)
          end
        end
      end
      return answer
    end

    def get_array_form(input_string)
      answer  = []
      input_string = input_string.split('*&^%$#!@')

      input_string.each do
        |x|
        y = x.split('!@#~%$@#!')
        a=y[0,y.size-1]
        b= []
        b.push(a)
        b.push(y[y.size-1])
        answer.push(b)
      end
      return answer
    end

    def fun(arr,string)
      sum = 0 
      maximum =0
      minimum = arr[0]
      arr.each do |a|
        sum = sum + a.to_i
        maximum = ((maximum>a.to_i)? maximum : a.to_i)
        minimum = ((minimum>a.to_i)? a.to_i : minimum)
      end
      avg = sum / arr.size 
      if string == "Sum"
        return sum
      elsif string == "Average"
        return avg
      elsif string == "Maximum"
        return maximum
      elsif string == "Minimum"
        return minimum
      end
    end

    def find_new_graph(index_array,graph_to_be_modified,query_function)
      return_hash = {}
      graph_to_be_modified.each do |g|
        arr = []
        index_array.each do |i|
          arr.push(g[0][i])
        end
        if return_hash.has_key? arr
          return_hash[arr].push(g[1].to_i)
        else
          return_hash[arr]=[]
          return_hash[arr].push(g[1].to_i)
        end
      end
      return_graph  = []
      return_hash.each do |r,s|
        a=[]
        a.push(r)
        a.push(fun(s,query_function))
        return_graph.push(a)
      end
      return return_graph
    end

    def get_header (input)
      input = input.split('*&^%$#!@')
      return input
    end

    def get_extra_select(param)
      s=[]
      param.each do
        |p,q|
        if p.include? "select_tag"
          if (q!="")
            s.push((q.split(' <=> ')).join('.'))
          end
        end
      end
      return s.uniq
    end

    def get_from_where(param)
      join = []
      relation = []
      where = []
      from = []
      param.each do
        |x,y|
        if x.include? "join_tag" and y!=""
          m = y.split(' <=> ')
          index = x.split("_")[2]
          z = params["relation_tag_"+index]
          if z != ""
            n = z.split(' <=> ')
            join.push((m[0]+ ".") + m[1] )
            relation.push((n[0]+ ".") + n[1] )
          end
        end
        # if x.include? "relation_tag" and y!=""
        #   m = y.split(' <=> ')
        #   relation.push((m[0]+ ".") + m[1] )
        # end
      end
      join.each_index do |i|
        if join[i].split(".")[0] != relation[i].split(".")[0]
          from.push(join[i].split(".")[0])
          from.push(relation[i].split(".")[0])
          where.push( (join[i] + "=") + relation[i])
        end
      end
      return from,where
    end

    def project_params
      params.require(:project).permit(:name,:description, :host, :dbusername,:adapter,:dbname)
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
        if x.include? "entity_name" and y!=""
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
end
