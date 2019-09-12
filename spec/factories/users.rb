# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  gender     :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :user do
    email       { Faker::Internet.unique.email }
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    gender      { User.genders.keys.sample }
  end
end
