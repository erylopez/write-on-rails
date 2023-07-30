class AddHashnodeBlogHandleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hashnode_blog_handle, :string
  end
end
