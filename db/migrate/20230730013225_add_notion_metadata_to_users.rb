class AddNotionMetadataToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notion_access_token, :string
    add_column :users, :notion_page_id, :string
  end
end
