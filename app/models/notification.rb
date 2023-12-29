class Notification < ApplicationRecord
  validates :subject, presence: { message: "not inserted" }
  validates :body, presence: { message: "not inserted" }
end
