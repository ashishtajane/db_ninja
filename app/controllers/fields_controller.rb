class FieldsController < ApplicationController

  def index
  end

  def new
    @types = Datatype.all
    @entity = Entity.find(params[:entity_id])
    @project = Project.find(params[:project_id])
    @field = Field.new()
  end

  def create
    @type = Datatype.find_by_name(params[:type_name])
    @entity = Entity.find(params[:entity_id])
    #debugger
    @field = Field.new(:name => params[:name] , :default => params[:default] , :null_value => boolval(params[:null_id].to_i), :datatype_id => @type.id, :entity_id => params[:entity_id].to_i, :type_arg1 => params[:type_arg1], :type_arg2 => params[:type_arg2] )
    if @field.save
      flash.now[:success]  = "Field Added"
      render  @entity
    else
      flash.now[:error]  = "Field Added"
      redirect_to @entity
    end
    #debugger
  end

  def show
  end

  def update
  end

  def edit
  end

  private
    def boolval(x)
      x==1
    end

end
