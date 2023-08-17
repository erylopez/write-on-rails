class AddDevtoColumnsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :devto_draft, :string
    add_column :posts, :devto_comments_count, :string
    add_column :posts, :devto_reactions, :string
    add_column :posts, :devto_views, :string
    add_column :posts, :devto_tags, :string
    add_column :posts, :devto_cover_image, :string
    add_column :posts, :devto_etag, :string
  end
end
