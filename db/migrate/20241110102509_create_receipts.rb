class CreateReceipts < ActiveRecord::Migration[8.0]
  def change
    create_table :receipts do |t|
      t.string :name, null: false
      t.string :body
      t.belongs_to :user, null: false, foreign_key: true
      t.references :provenance, polymorphic: true, null: false

      t.datetime :analyzed_at

      t.timestamps
    end
  end
end
