class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: { on_delete: :cascade }
      t.references :parent, foreign_key: { to_table: :comments, on_delete: :cascade }
      t.text :content
      t.string :hashnode_comment_id
      t.string :devto_comment_id
      t.string :hashnode_post_id
      t.string :devto_post_id

      t.timestamps
    end
  end
end
