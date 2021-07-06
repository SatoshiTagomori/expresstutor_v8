class CreatePaymentLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_logs do |t|
      t.references :line_user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.string :subscription
      #t.string :invoice
      #t.string :charge
      t.string :payment_intent
      t.text :log
      t.boolean :refund, default: false

      t.timestamps
    end
  end
end
