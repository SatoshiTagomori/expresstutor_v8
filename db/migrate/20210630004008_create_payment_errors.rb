class CreatePaymentErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_errors do |t|
      t.references :line_user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
