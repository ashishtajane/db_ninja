class UsersController < ApplicationController
  def home
  end

  def help
  end

  def show
  end

  def index
  end

  def autocomplete
	@posts = Post.autocomplete(:name, params[:q])
	respond_to do |format|
	  format.json { render json: @posts }
	end
  end

end
