class CreateImporterGoogleDriveFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :importer_google_drive_files do |t|
      t.string :drive_file_id, null: false
      t.string :name, null: false
      t.bigint :drive_version, null: false
      t.belongs_to :importer_google_drive_folder, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :importer_google_drive_files, [ :drive_file_id, :importer_google_drive_folder_id ], unique: true
  end
end
