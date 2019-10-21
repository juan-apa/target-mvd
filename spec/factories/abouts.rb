FactoryBot.define do
  factory :about do
    about { Faker::Lorem.sentence(word_count: 30) }
  end
end
