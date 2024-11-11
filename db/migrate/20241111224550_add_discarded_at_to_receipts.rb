class AddDiscardedAtToReceipts < ActiveRecord::Migration[8.0]
  def change
    add_column :receipts, :discarded_at, :datetime
    add_index :receipts, :discarded_at
  end
end
