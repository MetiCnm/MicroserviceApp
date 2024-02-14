class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :subject, null: false
      t.string :body, null: false
      t.boolean :published, default: false
      t.datetime :created_at, default: false
      t.datetime :updated_at, default: false
    end
  end
end
