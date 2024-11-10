class Importer::GoogleDrive::File < ApplicationRecord
  include Importer::Importable

  belongs_to :user
  belongs_to :folder, class_name: "Importer::GoogleDrive::Folder", foreign_key: :importer_google_drive_folder_id
  alias_method :source, :folder

  validates_presence_of :drive_file_id, :name, :drive_version
  validates :drive_file_id, uniqueness: { scope: :importer_google_drive_folder_id, message: "as already imported" }

  def self.from_source!(external_file, source:)
    file = find_or_create_by!(drive_file_id: external_file.id, importer_google_drive_folder_id: source.id) do |file|
      # create with...
      file.set_from_external(external_file)
    end

    # Update persisted record with external data. Shouldn't do anything if record was just created.
    file.with_lock do
      file.set_from_external(external_file)
      file.save!
    end

    file
  end

  def set_from_external(external_file)
    self.name = external_file.name
    self.drive_version = external_file.version
    # update content_file if drive_version increment
  end
end
