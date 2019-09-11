FactoryBot.define do
  factory :user do
    email     { Faker::Internet.unique.email }
    firstName { Faker::Name.first_name }
    lastName  { Faker::Name.last_name }
    gender    { User.genders.keys.sample }
  end
end
