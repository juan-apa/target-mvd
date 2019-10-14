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
#  read            :boolean
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_user_id          (user_id)
#

class Message < ApplicationRecord
  validates :body, presence: true
  validates :read, null: false

  belongs_to :conversation
  belongs_to :user

  after_create :send_notification

  private

  def send_notification
    conversation.matches.first.send_message_notification(user)
  end
end
