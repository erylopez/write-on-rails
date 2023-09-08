class Comment < ApplicationRecord
  belongs_to :post, inverse_of: :comments
  belongs_to :parent, optional: true, class_name: "Comment", inverse_of: :comments
  has_many :comments, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  validates :content, presence: true

  scope :root_comments, -> { where(parent_id: nil) }

  def from_platform
    if hashnode_comment_id.present?
      "Hashnode"
    else
      "Dev.to"
    end
  end
end
