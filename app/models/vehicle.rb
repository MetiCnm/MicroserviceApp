class Vehicle < ApplicationRecord
  validates :plate_number, presence: { message: "not inserted" },
            uniqueness: { message: "already exists" }
  belongs_to :user
end
