class UsersController < ApplicationController
  def home
  end

  def help
  end

  def show
  end

  def index
  end

  def list
    @users = User.all.paginate(page: params[:page])
  end

end
