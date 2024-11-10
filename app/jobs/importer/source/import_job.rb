class Importer::Source::ImportJob < ApplicationJob
  queue_as :default

  def perform(source_class)
    source_class.for_polling.find_each do |source|
      Rails.error.handle { source.poll }
    end
  end
end
