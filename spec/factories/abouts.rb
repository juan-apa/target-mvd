# == Schema Information
#
# Table name: abouts
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :about do
    content { Faker::Lorem.sentence(word_count: 30) }
  end
end
