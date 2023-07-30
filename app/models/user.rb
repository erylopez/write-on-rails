class User < ApplicationRecord
  include Onbordeable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :omniauthable,
    omniauth_providers: [:github]

  has_many :posts, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.github_access_token = auth.credentials.token
    end
  end

  def hashnode_ready?
    hashnode_access_token.present? && hashnode_username.present?
  end

  def devto_ready?
    devto_api_key.present?
  end

  def attributes_from_keys(*keys)
    keys.inject({}) do |hash_to_return, key|
      binding.pry
      hash_to_return.merge(key => send(key))
    end
  end
end
