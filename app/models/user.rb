class User < ApplicationRecord
  has_secure_password

  has_many :webauthn_credentials, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: true,
            format: { with: /\A[a-zA-Z0-9]{0,39}\z/, message: "can only contain alphanumeric characters" },
            length: { maximum: 39 }
  validates :password, length: { minimum: 6 }, on: :create

  normalizes :name, with: ->(name) { name.strip }

  def mfa_enabled?
    webauthn_credentials.any?
  end
end
