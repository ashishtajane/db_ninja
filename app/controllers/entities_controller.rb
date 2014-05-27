class EntitiesController < ApplicationController

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
    @entity = Entity.find(params[:id])
    @fields = @entity.fields
    @owner = @entity.project.user
    #debugger
  end

  def update
  end

  def edit
  end


end
