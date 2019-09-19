FactoryBot.define do
  factory :topic do
    title { Faker::Name.first_name }
  end
end
