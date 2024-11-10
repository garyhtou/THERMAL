class Receipt::AnalyzeJob < ApplicationJob
  queue_as :default

  def perform(receipt)
    receipt.analyze
  end
end
