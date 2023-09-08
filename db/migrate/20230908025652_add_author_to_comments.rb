class AddAuthorToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :author_name, :string
    add_column :comments, :author_avatar, :string, default: "/default-avatar.png"
  end
end
