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

  def ordered_messages
    messages.order(created_at: :desc)
  end
end
