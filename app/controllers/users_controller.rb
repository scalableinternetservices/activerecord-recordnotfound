class UsersController < ApplicationController
  before_action :require_login, only: [:show]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully."
    else
      flash.now[:alert] = "There was an error creating your account."
      render :new
    end
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    @posts = @user.posts
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password, :password_confirmation)
  end
end
