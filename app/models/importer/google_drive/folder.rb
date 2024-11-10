class Importer::GoogleDrive::Folder < ApplicationRecord
  include Importer::Sourceable

  belongs_to :user
  has_many :files, class_name: "Importer::GoogleDrive::File", foreign_key: :importer_google_drive_folder_id, dependent: :destroy

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
    files = drive.fetch_all(items: :files) do |page_token|
      drive.list_files(**drive_query(page_token:))
    end

    files.each do |file|
      begin
        record = Importer::GoogleDrive::File.from_source!(file, source: self)
        puts "Imported #{record.id}: #{record.name}"
      rescue => e
        Rails.error.unexpected(e, context: { folder: self.to_gid.to_s, drive_file_id: file.id })
      end
    end
  end

  def drive
    @drive ||= Google::Apis::DriveV3::DriveService.new.tap do |drive|
      drive.authorization = user.google_credentials
    end
  end

  private

  def drive_query(**additional)
    {
      # File belongs to this folder and is not trashed
      q: "'#{drive_file_id}' in parents and trashed = false",

      # Order by recency (the most recent timestamp from the file's date-time fields
      order_by: "recency desc",

      # By default, the API only returns `id`, `kind`, `mime_type`, and `name`.
      # https://developers.google.com/drive/api/guides/fields-parameter
      # It's very unexpected, but `nextPageToken` needs to be explicitly requested.
      # https://stackoverflow.com/questions/64287605/drive-list-files-doesnt-have-nextpagetoken-when-fields-is-present
      fields: "nextPageToken,incompleteSearch,kind,files(id,name,mimeType,md5Checksum)"
    }.merge(additional)
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
