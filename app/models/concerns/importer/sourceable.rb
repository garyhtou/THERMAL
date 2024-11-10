module Importer
  # Importer's sources (e.g. Importer::GoogleDrive::Folder) must implement this interface.
  module Sourceable
    extend ActiveSupport::Concern

    included do
      def poll
        # Checks for new files from the source and imports them by calling `Importer::Importable#from_source`.
        raise NotImplementedError, "#{self.class} must implement #poll"
      end
    end
  end
end
