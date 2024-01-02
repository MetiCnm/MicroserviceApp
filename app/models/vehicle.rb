class Vehicle < ApplicationRecord
  validates :plate_number, presence: { message: "not inserted" }
  belongs_to :user
  has_many :fines
end
