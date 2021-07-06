class CreateLineUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :line_users do |t|
      t.string :line_id
      t.string :display_name
      t.string :picture
      t.boolean :admin, default: false
      t.boolean :teacher, default: false
      t.string :customer
      t.string :subscription

      t.timestamps
    end
  end
end
