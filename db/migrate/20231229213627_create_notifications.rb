class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :subject, null: false
      t.string :body, null: false
      t.boolean :published, default: false
      t.timestamps
    end
  end
end
