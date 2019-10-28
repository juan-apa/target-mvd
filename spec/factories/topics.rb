# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_topics_on_title  (title) UNIQUE
#

FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.unique.characters(number: 10) }
    image { Rack::Test::UploadedFile.new('spec/fixtures/test_image.png', 'image/png') }
  end
end
