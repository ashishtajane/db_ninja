class ProjectsController < ApplicationController

  before_action :get_instance_variables ,only: [:show , :update , :edit]
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

  

  private

  def project_params
    params.require(:project).permit(:name,:description, :host, :dbusername,:dbpassword,:adapter)
  end

  private

    def get_instance_variables
      @project = Project.find(params[:id])
      @owner = @project.user
    end

  # def owner_of_the_project
  #   @collaborating_users = Project.find(params[:id]).collaborating_users
  #   unless @collaborating_users.include? current_user
  #     flash[:error] = "You are not the collaborator for this project"
  #     redirect_to root_url
  #   end
  # end

end
