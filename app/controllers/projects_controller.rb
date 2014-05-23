class ProjectsController < ApplicationController

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

end
