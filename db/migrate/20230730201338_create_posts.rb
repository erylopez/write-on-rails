class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :md_content
      t.string :hashnode_id
      t.string :devto_id
      t.string :notion_id
      t.string :medium_id
      t.string :tags
      t.references :user

      t.timestamps
    end
  end
end
