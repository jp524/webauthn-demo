class Sessions::UsersController < ApplicationController
  def new;end

  def create
    if (user = User.authenticate_by(name: params[:name], password: params[:password]))
      session[:user_id] = user.id
      session[:user_expires_at] = 1.hour.from_now
      redirect_to root_path
    else
      redirect_to new_sessions_user_path, alert: "Login failed. Please verify your username and password."
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_expires_at] = nil
    redirect_to root_path, notice: "Successfully logged out."
  end
end
