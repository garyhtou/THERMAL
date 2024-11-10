module Importer
  # Importer's items (e.g. Importer::GoogleDrive::File) must implement this interface.
  module Importable
    extend ActiveSupport::Concern

    class_methods do
      def from_source!(external_item, source:)
        # Idempotently creates or updates an item from an it's external version.
        raise NotImplementedError, "#{self.class} must implement ::from_source!(external_item, sourceable:)"
      end
    end

    included do
      # Only one of these two fields should be used.
      if columns_hash["content_text"].nil?
        has_one_attached :content_file
        validates :content_file, presence: true # TODO: is this same as validate attached?
      end

      before_validation :set_user_from_source, on: :create
      validate :same_user_as_source

      after_create_commit do
        # TODO: queue job to texutalize content & create/update Receipt
      end
    end

    def content
      try(:content_text) || content_file
    end

    def source
      # Returns the sourceable object that this item is associated with.
      raise NotImplementedError, "#{self.class} must alias the sourceable association as source"
    end

    private

    def set_user_from_source
      self.user = source&.user
    end

    def same_user_as_source
      errors.add(:user, "must be the same as source's user") unless user == source&.user
    end
  end
end
