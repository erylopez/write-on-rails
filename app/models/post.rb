class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true

  def self.from_notion(response)
    where(user_id: response[:user_id], notion_id: response[:id]).first_or_create do |post|
      post.title = response[:title]
      post.md_content = response[:md]
    end
  end
end
