class CollaborationsController < ApplicationController
  before_action :get_instance_variables 
  before_action :check_owner , only: [:create]
  def index
    @collaborators=Project.find(params[:project_id].to_i).collaborating_users.paginate(page: params[:page])
  end

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    @collaboration = Collaboration.new(:project_id => params[:pid].to_i , :user_id => @user.id)
    
    if @collaboration.save
      Collaboration.create(:project_id => params[:pid].to_i , :user_id => @user.id)
      flash[:success]  = "Collaborator Added to the project"
    end
      flash[:error]  = "Collaborator already exists"
      redirect_to Project.find(params[:pid].to_i)
  end

  private

    def get_instance_variables
      @project = Project.find(params[:project_id])
      @owner = @project.user
    end

end
