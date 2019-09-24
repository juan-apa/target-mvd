FactoryBot.define do
  factory :target do
    title     { Faker::Lorem.unique.characters(number: 10) }
    radius    { Faker::Number.number(digits: 3) }
    latitude  { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    user      { create :user }
    topic     { create :topic }
  end
end
