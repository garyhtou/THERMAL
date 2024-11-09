class DropProviderAccessTokenFromUser < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :provider_access_token
  end
end
