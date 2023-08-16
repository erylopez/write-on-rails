class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :github_avatar, :string
    add_column :users, :nickname, :string
    add_column :users, :github_company, :string
    add_column :users, :github_location, :string
    add_column :users, :github_bio, :string
  end
end
