class Fine < ApplicationRecord
  validates :reason, presence: { message: "not inserted" }
  validates :place, presence: { message: "not inserted" }
  validates :issue_time, presence: { message: "not inserted" }
  validates :amount, presence: { message: "not inserted" }, numericality: { message: "not an integer or a float value" }
  belongs_to :vehicle
  belongs_to :user
end
