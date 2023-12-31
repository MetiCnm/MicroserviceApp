class User < ApplicationRecord
  validates :email, presence: { message: "not inserted" }, uniqueness: { message: "not unique" },
            format: {with: /\A[^@\s]+@[^@\s]+\z/, message: "should be in valid format"}
  validates :password, presence: { message: "not inserted" }
  validates :name, presence: { message: "not inserted" }
  validates :surname, presence: { message: "not inserted" }
  validate :national_identification_number_check
  validate :phone_number_check
  validate :date_of_birth_check
  has_many :vehicles

    def date_of_birth_check
      if date_of_birth.present? && date_of_birth > Date.today
        errors.add(:date_of_birth, "can't be in the future")
      end
    end

  def national_identification_number_check
    if national_identification_number.present?
      unless national_identification_number.match(/[A-Z][0-9]{8}[A-Z]/)
        errors.add(:national_identification_number, "is not in the right format")
      end
    end
  end

  def phone_number_check
    if phone_number.present?
      unless phone_number.match(/(067|068|069)\d{7}/)
        errors.add(:national_identification_number, "is not in the right format")
      end
    end
  end
end
