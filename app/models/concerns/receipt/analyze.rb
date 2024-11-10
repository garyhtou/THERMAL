class Receipt
  module Analyze
    extend ActiveSupport::Concern

    def analyze
      text = Textualizer.new(provenance.content).text
      update(body: text.presence, analyzed_at: Time.current)
    end

    def analyze_later
      Receipt::AnalyzeJob.perform_later(self)
    end
  end
end
