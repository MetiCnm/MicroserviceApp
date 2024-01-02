class CreateFines < ActiveRecord::Migration[7.1]
  def change
    create_table :fines do |t|
      t.string :reason, null: false
      t.string :place, null: false
      t.datetime :issue_time, null: false
      t.float :amount, null: false
      t.boolean :payment_status, default: false
      t.float :penalty_amount, default: 0.00
      t.references :user
      t.references :vehicle
      t.timestamps
    end
  end
end
