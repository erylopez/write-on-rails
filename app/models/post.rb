class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, inverse_of: :post, dependent: :destroy

  validates :title, presence: true

  def self.from_notion(response)
    where(user_id: response[:user_id], notion_id: response[:id]).first_or_create do |post|
      post.title = response[:title]
      post.md_content = response[:md]
    end
  end

  def total_views
    hashnode_views.to_i + devto_views.to_i
  end

  def total_comments
    hashnode_reply_count.to_i + devto_comments_count.to_i
  end

  def total_likes
    hashnode_reactions.to_i + devto_reactions.to_i
  end

  def published?(platform)
    case platform
    when "Hashnode"
      return true unless hashnode_draft
    when "Dev.to"
      return true unless devto_draft
    end
    false
  end
end
