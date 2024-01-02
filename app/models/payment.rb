class Payment < ApplicationRecord
  validates :credit_card_number, presence: { message: "not inserted" },
            numericality: { message: "not an integer or a float value" }
  validate :credit_card_number_check
  validates :expiration_date, presence: { message: "not inserted" }
  validate :expiration_date_check
  validates :card_verification_number, presence: { message: "not inserted" }
  validate :card_verification_number_check
  belongs_to :fine

  def credit_card_number_check
    if credit_card_number.present?
      unless credit_card_number.match(/[0-9]{16}/)
        errors.add(:credit_card_number, "is not in the right format")
      end
    end
  end

  def expiration_date_check
    if expiration_date.present?
      unless expiration_date.match(/(0[1-9]|1[0-2])\/?([0-9]{2})/)
        errors.add(:expiration_date, "is not in the right format")
      end
    end
  end

  def card_verification_number_check
    if card_verification_number.present?
      unless card_verification_number.match(/[0-9]{3}/)
        errors.add(:card_verification_number, "is not in the right format")
      end
    end
  end
end
