class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    admin = AdminUser.from_omniauth request.env["omniauth.auth"]
    if admin
      sign_in_and_redirect admin
    else
      flash.notice = "Email not found in our database. Please contact administrator."
      redirect_to new_admin_user_session_url
    end
  end

  alias_method :google_oauth2, :all

end
