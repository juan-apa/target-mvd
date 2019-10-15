# == Schema Information
#
# Table name: conversations
#
#  id :integer          not null, primary key
#

class Conversation < ApplicationRecord
  paginates_per 20

  has_many :matches, dependent: :nullify
  has_many :messages, dependent: :destroy

  def opposite_user_unread_messages_count(user)
    messages.where(read: false).where.not(user_id: user.id).count
  end

  def opposite_user_mark_messages_as_read!(user)
    messages.where.not(user_id: user.id).update_all(read: true)
  end

  def ordered_messages
    messages.order(created_at: :desc)
  end
end
