class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password, null: false
      t.string :name, null: false
      t.string :surname, null: false
      t.string :national_identification_number
      t.date :date_of_birth
      t.string :phone_number
      t.string :role
      t.timestamps
    end
  end
end
