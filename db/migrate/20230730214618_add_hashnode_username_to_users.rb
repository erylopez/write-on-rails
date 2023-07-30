class AddHashnodeUsernameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hashnode_username, :string
  end
end
