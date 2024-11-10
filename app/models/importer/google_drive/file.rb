class Importer::GoogleDrive::File < ApplicationRecord
  include Importer::Importable

  belongs_to :user
  belongs_to :folder, class_name: "Importer::GoogleDrive::Folder", foreign_key: :importer_google_drive_folder_id
  alias_method :source, :folder

  validates_presence_of :drive_file_id, :name
  validates :drive_file_id, uniqueness: { scope: :importer_google_drive_folder_id, message: "as already imported" }

  delegate :drive, to: :folder

  def extensionless_name
    return name if extension.nil?

    File.basename(name, extension)
  end

  def extension
    File.extname(name).presence
  end

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

    # Check if the file has changed (or if not attached)
    if !content_file.attached? || content_file.blob.checksum != hexdigest_to_base64(external_file.md5_checksum)
      # Active Storage will close the `external_blob_file` Tempfile for us
      self.content_file.attach(io: external_blob_file, filename: name, content_type: external_file.mime_type)
    end
  end

  private

  def external_blob_file
    # Make sure to close this file...
    basename = [ extensionless_name, extension ]
    temp = Tempfile.create(basename)
    drive.get_file(drive_file_id, download_dest: temp.path)
    temp
  end

  def hexdigest_to_base64(hexdigest)
    # Google Drive uses MD5 hexdigest for checksums.
    # We need to convert it to base64 for comparison against Active Storage's.
    [ [ hexdigest ].pack("H*") ].pack("m").strip
  end
end
