class User < ApplicationRecord
  include Onbordeable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :omniauthable,
    omniauth_providers: [:github]

  has_many :posts, dependent: :destroy
  validates :uid, presence: true

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

  def get_hashnode_publication_id
    hashnode_publication_id || sync_publication_id_from_hashnode
  end

  def sync_publication_id_from_hashnode
    publications = Hashnode::GetPublications.new(
      authorization_code: hashnode_access_token, username: hashnode_username
    ).call
    publication_id = publications&.dig("data", "user", "publication", "_id")

    return false unless publication_id

    update(
      hashnode_publication_id: publication_id,
      hashnode_blog_handle: publications.dig("data", "user", "blogHandle")
    )

    hashnode_publication_id
  rescue HTTParty::Error, SocketError, Errno::ECONNRESET, Errno::ETIMEDOUT
    false
  end
end
