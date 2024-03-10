class CreateFines < ActiveRecord::Migration[7.1]
  def change
    create_table :fines do |t|
      t.string :_id, null: false
      t.string :reason, null: false
      t.string :place, null: false
      t.datetime :issue_time, null: false
      t.float :amount, null: false
      t.boolean :payment_status, default: false
      t.float :penalty_amount, default: 0.00
      t.bigint :user_id, null: false
      t.bigint :vehicle_id, null: false
      t.datetime :created_at
      t.datetime :updated_at
      t.string :vehicle_plate_number
      t.string :user_name
      t.string :user_surname
    end
  end
end
