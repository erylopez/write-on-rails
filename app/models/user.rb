class User < ApplicationRecord
  include Onbordeable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :omniauthable,
    omniauth_providers: [:github]

  has_many :posts, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email               = auth.info.email
      user.name                = auth.info.name
      user.nickname            = auth.info.nickname
      user.github_avatar       = auth.info.image
      user.password            = Devise.friendly_token[0, 20]
      user.github_access_token = auth.credentials.token
      user.github_bio          = auth.extra.raw_info.bio
      user.github_company      = auth.extra.raw_info.company
      user.github_location     = auth.extra.raw_info.location
    end
  end

  def hashnode_ready?
    hashnode_access_token.present? && hashnode_username.present?
  end

  def devto_ready?
    devto_api_key.present?
  end
end
