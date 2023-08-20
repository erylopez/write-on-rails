class ChangesColumnTypeToDraftsFromPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :hashnode_draft, :boolean, using: 'hashnode_draft::boolean'
    change_column :posts, :devto_draft, :boolean, using: 'devto_draft::boolean'
  end
end
