# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  conversation_id :integer
#  body            :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  read            :boolean          default(FALSE), not null
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_user_id          (user_id)
#

FactoryBot.define do
  factory :message do
    body { Faker::Lorem.sentence(word_count: 10) }
    read { false }
    user
    conversation
  end
end
