class Importer::GoogleDrive::Folder < ApplicationRecord
  include Importer::Sourceable

  belongs_to :user

  # `google_drive_channel_id` is a token that **we generate** to uniquely identify the Google Drive channel.
  # https://developers.google.com/drive/api/guides/push#required-properties
  has_secure_token :google_drive_channel_id
  validates_length_of :google_drive_channel_id, maximum: 64 # This is a Google requirement
  validates :google_drive_channel_id, presence: true, uniqueness: true

  URL_REGEX = /\Ahttps:\/\/drive.google.com\/drive\/u\/\d\/folders\/(?<file_id>[a-zA-Z0-9_-]+)(?:\?.*)?\z/
  validates :drive_url, presence: true, format: { with: URL_REGEX }
  validates :drive_file_id, presence: true, uniqueness: { scope: :user_id, message: "is already configured" }

  before_validation :extract_drive_file_id, if: :drive_url_changed?
  after_validation :unify_drive_url_and_file_errors

  after_create_commit do
    # TODO: configure channel webhook and keep renewing it before expiration
  end

  def poll
    files_in_folder = "'#{drive_file_id}' in parents and trashed = false"

    files = drive.fetch_all(items: :files) do |page_token|
      drive.list_files(q: files_in_folder, page_token:)
    end

    files.each do |file|
      # TODO: implement
      puts file.name
      # Importer::GoogleDrive::File.from_source(file, sourceable: self)
    end
  end

  private

  def drive
    @drive ||= Google::Apis::DriveV3::DriveService.new.tap do |drive|
      drive.authorization = user.google_credentials
    end
  end

  def extract_drive_file_id
    return unless drive_url.present?

    # Google Drive treats folders as files with a special MIME type.
    self.drive_file_id = drive_url.match(URL_REGEX)&.[](:file_id)
  end

  def unify_drive_url_and_file_errors
    # A validation error on folder URL likely also means Folder ID will fail validation. This is because we extract
    # the folder ID from the URL. So, we remove the redundant error message.
    errors.delete(:drive_file_id) if errors[:drive_url].any?

    # If the folder ID is already taken, we want to show the error on the URL field instead.
    if (taken_error = errors.delete(:drive_file_id, :taken))
      # Move uniqueness error to the URL field
      errors.add(:drive_url, taken_error)
    end
  end
end
