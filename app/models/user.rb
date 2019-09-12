class User < ApplicationRecord
  enum genders: { male: 0, female: 1 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :gender, presence: true, inclusion: { in: genders.keys }
  validates :first_name, presence: true, length: { minimum: 3, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 3, maximum: 20 }
end
