class AddHashnodePublicationIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hashnode_publication_id, :string
  end
end
