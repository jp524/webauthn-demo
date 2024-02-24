module UserAuthentication
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :exception
    helper_method :current_user

    def require_user_authentication
      return if user_logged_in?

      redirect_to new_sessions_user_path, alert: "Please log in to continue."
    end

    def current_user
      validate_session
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def user_logged_in?
      !!current_user
    end

    def validate_session
      return if session[:user_expires_at].nil?

      session[:user_id] = nil if session[:user_expires_at] < Time.current
    end
  end
end
