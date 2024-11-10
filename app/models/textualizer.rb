# frozen_string_literal: true

class Textualizer
  def initialize(content)
    @content = content # may either be an ActiveStorage::Attachment or a String
    @file = nil
  end

  def text
    return @content if @content.is_a?(String)

    @content.open do |file|
      @file = file

      case @content.content_type
      when "application/pdf"
        return handle_pdf
      when /^image\//
        return handle_image
      else
        raise ArgumentError, "Unsupported content type: #{@content.content_type}"
      end
    end
  end

  def handle_pdf
    convert_pdf_to_text
    handle_image
  end

  def handle_image
    image = RTesseract.new(@file.path)
    image.to_s
  end

  def convert_pdf_to_text
    image = self.class.pdf_to_image(@file)
    @file.close
    @file = image
  end

  def self.pdf_to_image(file)
    # TODO: explore Pdftoppm
    # active_storage/previewer/poppler_pdf_previewer.rb
    image = Vips::Image.pdfload(file.path, n: -1, dpi: 300) # -1 means all pages
    result = Tempfile.create([ "image", ".png" ])
    image.pngsave(result.path)
    result
  end
end
