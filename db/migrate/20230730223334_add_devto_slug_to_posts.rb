class AddDevtoSlugToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :devto_slug, :string
    add_column :posts, :devto_url, :string
  end
end
