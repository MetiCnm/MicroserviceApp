class Notification < ApplicationRecord
  include ActiveModel::Serializers::Xml
  validates :subject, presence: { message: "not inserted" }
  validates :body, presence: { message: "not inserted" }
end
