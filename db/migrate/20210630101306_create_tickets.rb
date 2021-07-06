class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.references :line_user, null: false, foreign_key: true
      t.references :payment_log, null: false, foreign_key: true
      t.string :subscription
      t.datetime :valid_date
      t.integer :amount

      t.timestamps
    end
  end
end
