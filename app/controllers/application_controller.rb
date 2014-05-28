class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  #protect_from_forgery
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
