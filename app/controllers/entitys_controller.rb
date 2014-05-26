class EntitysController < ApplicationController

  def index
    @entities = Project.find(params[:project_id]).entitys
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
    redirect_to project_entitys_path(Project.find(params[:project_id]))
  end

  def show
  end

  def update
  end

  def edit
  end


end
