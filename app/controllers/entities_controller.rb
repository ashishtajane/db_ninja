class EntitiesController < ApplicationController

  before_action :get_instance_variables ,only: [:new,:index,:show,:update,:edit,:destroy]
  before_action :get_entity , only: [:show,:update,:edit]
  before_action :check_collaborator,only: [:index,:show,:update,:edit]
  before_action :check_owner , only: [:new]
  before_action :check_url, only: [:show,:update,:edit]

  def index
    @entities = Project.find(params[:project_id]).entities
  end

  def new
    @entity = Entity.new()
  end

  def create
    @entity = Entity.new(:project_id => params[:project_id].to_i , :model_name => params[:model_name] ,:table_name => params[:table_name])
    if @entity.save 
      Entity.create(:project_id => params[:project_id].to_i , :model_name => params[:model_name] ,:table_name => params[:table_name])
      flash[:success]="New Entity Added"
    else
      flash[:error]="Already existing entity"
    end
    redirect_to project_entities_path(Project.find(params[:project_id]))
  end

  def show
    @fields = @entity.fields
  end

  def update
  end

  def edit
  end

  def destroy
    Entity.find(params[:id]).destroy
    redirect_to project_entities_path(@project)
  end

  private

    def get_instance_variables
      @project = Project.find(params[:project_id])
      @owner = @project.user
    end

    def get_entity
      @entity = Entity.find(params[:id])
    end

end
