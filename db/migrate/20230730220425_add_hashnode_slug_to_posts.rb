class AddHashnodeSlugToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :hashnode_slug, :string
  end
end
