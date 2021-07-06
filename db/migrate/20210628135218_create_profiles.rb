class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :line_user, null: false, foreign_key: true
      t.string :email
      t.string :name
      t.string :cname
      t.references :pref, null: false, foreign_key: true
      t.string :tel
      t.integer :year
      t.integer :month

      t.timestamps
    end
  end
end
