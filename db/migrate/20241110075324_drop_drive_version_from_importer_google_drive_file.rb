class DropDriveVersionFromImporterGoogleDriveFile < ActiveRecord::Migration[8.0]
  def change
    remove_column :importer_google_drive_files, :drive_version
  end
end
