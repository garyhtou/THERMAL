class CreateImporterGoogleDriveFolders < ActiveRecord::Migration[8.0]
  def change
    create_table :importer_google_drive_folders do |t|
      t.string :drive_url, null: false
      t.string :drive_file_id, null: false
      t.references :user, null: false, foreign_key: true
      t.string :google_drive_channel_id

      t.timestamps null: false
    end
    add_index :importer_google_drive_folders, :google_drive_channel_id, unique: true
    add_index :importer_google_drive_folders, [ :user_id, :drive_file_id ], unique: true
  end
end
