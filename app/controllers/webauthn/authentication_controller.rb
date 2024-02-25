class Webauthn::AuthenticationController < ApplicationController
  before_action :ensure_user_not_authenticated
  before_action :ensure_login_initiated

  def new
    @user = user
  end

  def options
    get_options = WebAuthn::Credential.options_for_get(allow: user.webauthn_credentials.pluck(:external_id))

    session[:authentication_challenge] = get_options.challenge

    render json: get_options
  end

  def create
    webauthn_credential = WebAuthn::Credential.from_get(params)

    credential = user.webauthn_credentials.find_by(external_id: webauthn_credential.id)

    begin
      webauthn_credential.verify(
        session[:authentication_challenge],
        public_key: credential.public_key,
        sign_count: credential.sign_count
      )

      credential.update!(sign_count: webauthn_credential.sign_count)
      session[:user_id] = session[:webauthn_user_id]
      session[:webauthn_user_id] = nil

      # Pass `redirect URL` to Stimulus controller. Rails `redirect_to` does not work
      render json: { redirect: static_pages_path }, status: :ok
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_entity
    end
  end

  private

  def user
    @user ||= User.find(session[:webauthn_user_id])
  end

  def ensure_login_initiated
    redirect_to new_sessions_user_path if session[:webauthn_user_id].blank?
  end

  def ensure_user_not_authenticated
    redirect_to root_path if current_user
  end
end
