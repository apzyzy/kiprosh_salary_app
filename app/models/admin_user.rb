class AdminUser < ApplicationRecord
  devise :database_authenticatable,
    :omniauthable, omniauth_providers: [:google_oauth2]

  # Devise override to ignore the password requirement if the user is authenticated with Google
  def password_required?
    provider.present? ? false : super
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first
  end
end
