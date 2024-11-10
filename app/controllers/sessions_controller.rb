class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(user_name: session_params[:user_name])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid username or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end

  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end
end
