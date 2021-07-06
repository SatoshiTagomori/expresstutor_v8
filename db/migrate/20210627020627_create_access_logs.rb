class CreateAccessLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :access_logs do |t|
      t.references :line_user, null: false, foreign_key: true
      t.string :ip

      t.timestamps
    end
  end
end
