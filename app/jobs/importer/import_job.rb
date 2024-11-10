class Importer::ImportJob < ApplicationJob
  queue_as :default

  SOURCE_CLASSES = [ Importer::GoogleDrive::Folder ]

  def perform
    SOURCE_CLASSES.each do |source_class|
      Importer::Source::ImportJob.perform_later(source_class)
    end
  end
end
