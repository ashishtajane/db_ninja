class FieldsController < ApplicationController
  before_action :get_instance_variables 
  before_action :check_collaborator
  before_action :check_owner , only: [:new]
  before_action :check_url, only: [:new]
  #before_action :owner_of_the_field, only: [:new]
  def index
  end

  def new
    @types = Datatype.all
    @field = Field.new()
  end

  def create
    debugger
    @type = Datatype.find_by_name(params[:type_name])
    #@field = Field.new(:name => params[:name] , :default => params[:default] , :null_value => boolval(params[:null_id].to_i), :datatype_id => @type.id, :entity_id => params[:entity_id].to_i, :type_arg1 => params[:type_arg1], :type_arg2 => params[:type_arg2] )
    if @field.save
      flash.now[:success]  = "Field Added"
      redirect_to project_entity_path(@project,@entity)
    else
      flash.now[:error]  = "Some Error has occured please try again"
      redirect_to new_project_entity_field_path(@project,@entity)
    end
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

    def get_instance_variables
      @project = Project.find(params[:project_id])
      @owner = @project.user
      @entity = Entity.find(params[:entity_id])
    end

    # def owner_of_the_field
    #   @owner = @project.user
    #   unless current_user == @owner
    #     flash[:error] = "Sorry! You are not the owner of this project"
    #     redirect_to project_entity_path(@project,@entity)
    #   end
    # end
end
