class FieldsController < ApplicationController

  def index
  end

  def new
    #debugger
    @type = Datatype.all
    @entity = Entity.find(params[:entity_id])
    @project = Project.find(params[:project_id])
    @field = Field.new()
  end

  def create
    debugger
  end

  def show
  end

  def update
  end

  def edit
  end



end
