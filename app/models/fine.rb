class Fine < ApplicationRecord
  validates :reason, presence: { message: "not inserted" }
  validates :place, presence: { message: "not inserted" }
  validates :issue_time, presence: { message: "not inserted" }
  validate :issue_time_cannot_be_in_the_future
  validates :amount, presence: { message: "not inserted" }, numericality: { message: "not an integer or a float value" }
  belongs_to :vehicle
  belongs_to :user
  has_one :payment

  def issue_time_cannot_be_in_the_future
    if issue_time.present? && issue_time > DateTime.current
      errors.add(:issue_time, "cannot be in the future")
    end
  end
end
