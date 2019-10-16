FactoryBot.define do
  factory :message do
    body { Faker::Lorem.sentence(word_count: 10) }
    user
    conversation
  end
end
