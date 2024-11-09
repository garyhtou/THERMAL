# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      # Basic info
      t.string :first_name
      t.string :last_name
      t.string :email, null: false

      # Omniauth
      t.string :provider
      t.string :provider_uid

      # Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, %i[provider provider_uid], unique: true
  end
end
