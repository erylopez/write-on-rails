class AddHashnodeColumnsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :hashnode_url, :string
    add_column :posts, :hashnode_cover_image, :string
    add_column :posts, :hashnode_reactions, :string
    add_column :posts, :hashnode_views, :string
    add_column :posts, :hashnode_draft, :string
    add_column :posts, :hashnode_reply_count, :string
    add_column :posts, :hashnode_response_count, :string
    add_column :posts, :hashnode_etag, :string
  end
end
