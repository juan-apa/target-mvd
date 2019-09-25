# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  title      :string(40)       not null
#  radius     :integer          not null
#  latitude   :decimal(10, 6)   not null
#  longitude  :decimal(10, 6)   not null
#  user_id    :integer
#  topic_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_targets_on_latitude_and_longitude  (latitude,longitude)
#  index_targets_on_topic_id                (topic_id)
#  index_targets_on_user_id                 (user_id)
#

FactoryBot.define do
  factory :target do
    title     { Faker::Lorem.unique.characters(number: 10) }
    radius    { Faker::Number.number(digits: 3) }
    latitude  { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    user
    topic

    factory :target_with_invalid_topic do
      topic  { nil }
      topic_id { 'invalid_topic_id' }
    end
  end


end
