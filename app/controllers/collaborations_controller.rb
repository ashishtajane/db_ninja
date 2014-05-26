class CollaborationsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    @collaboration = Collaboration.new(:project_id => params[:pid].to_i , :user_id => @user.id)
    
    if @collaboration.save
      Collaboration.create(:project_id => params[:pid].to_i , :user_id => @user.id)
      flash[:success]  = "project Added"
    end
      
    redirect_to Project.find(params[:pid].to_i)

  end

end
