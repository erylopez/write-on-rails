class AddDevtoApiKeyToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :devto_api_key, :string
  end
end
