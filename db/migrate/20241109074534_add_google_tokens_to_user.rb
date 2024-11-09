class AddGoogleTokensToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider_access_token, :string
    add_column :users, :provider_refresh_token, :string
  end
end
