class Sessions::UsersController < ApplicationController
  before_action :require_user_authentication, only: :destroy
  before_action :user_not_logged_in, only: %i[new create]

  def new;end

  def create
    if (user = User.authenticate_by(name: params[:name], password: params[:password]))
      if user.mfa_enabled?
        create_with_mfa_enabled(user)
      else
        create_without_mfa_enabled(user)
      end
    else
      redirect_to new_sessions_user_path, alert: "Login failed. Please verify your username and password."
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_expires_at] = nil
    redirect_to root_path, notice: "Successfully logged out."
  end

  private

  def create_with_mfa_enabled(user)
    session[:webauthn_user_id] = user.id
    redirect_to new_webauthn_authentication_path
  end

  def create_without_mfa_enabled(user)
    session[:user_id] = user.id
    session[:user_expires_at] = 1.hour.from_now
    redirect_to static_pages_path, notice: "Successfully logged in."
  end

  def user_not_logged_in
    redirect_to static_pages_path if current_user
  end
end
