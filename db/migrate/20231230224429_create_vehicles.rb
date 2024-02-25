class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.string :plate_number, null: false
      t.string :vehicle_type
      t.string :make
      t.integer :production_year
      t.bigint :user_id
      t.datetime :created_at
      t.datetime :modified_at
    end
  end
end
