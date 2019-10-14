FactoryBot.define do
  factory :message do
    body { Faker::Lorem.words(number: 10).join(' ') }
    user
    conversation
  end
end
