class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  #protect_from_forgery
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
    end

    def check_collaborator
      collaborating_users = @project.collaborating_users
      unless collaborating_users.include? current_user
        flash[:error] = "You are not the collaborator for this project"
        redirect_to root_url
      end
    end

    def check_owner
      unless current_user==@owner
        flash[:error] = "You are not the owner for this project"
        #debugger
        redirect_to project_path(@project)
      end
    end

    def check_url
      unless  @entity.project == @project
        flash[:error]="Wrong Url"
        redirect_to root_url
      end
    end
end
