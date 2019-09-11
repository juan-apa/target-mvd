class User < ApplicationRecord
  enum genders: { male: 0, female: 1 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :gender, presence: true, inclusion: { in: genders.keys }
  validates :firstName, presence: true, length: { minimum: 3, maximum: 20 }
  validates :lastName, presence: true, length: { minimum: 3, maximum: 20 }
end
