class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.string :credit_card_number, null: false
      t.string :expiration_date, null: false
      t.string :card_verification_number, null: false
      t.float :amount, default: 0.00
      t.references :response
      t.timestamps
    end
  end
end
