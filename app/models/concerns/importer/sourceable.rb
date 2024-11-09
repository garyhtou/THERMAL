module Importer
  # Importer's sources must implement this interface.
  module Sourceable
    extend ActiveSupport::Concern

    included do
      def poll
        # Checks for new files from the source and imports them by calling `Importer::Itemable#from_source`.
        raise NotImplementedError, "#{self.class} must implement #poll"
      end
    end
  end
end
