class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :price
      t.integer :tickets
      t.string :valid_date
      t.boolean :status, default: true
      t.boolean :subscription, default: true
      t.string :comment
      t.string :price_id

      t.timestamps
    end
  end
end
