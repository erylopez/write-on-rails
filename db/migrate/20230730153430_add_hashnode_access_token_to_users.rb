class AddHashnodeAccessTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hashnode_access_token, :string
  end
end
