class Comment < ApplicationRecord
  belongs_to :post, inverse_of: :comments
  belongs_to :parent, optional: true, class_name: "Comment", inverse_of: :comments
  has_many :comments, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  validates :content, presence: true
end
