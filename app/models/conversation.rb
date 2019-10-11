# == Schema Information
#
# Table name: conversations
#
#  id :integer          not null, primary key
#

class Conversation < ApplicationRecord
  has_many :matches, dependent: :nullify
  has_many :messages, dependent: :destroy

  def paginated_messages(page)
    messages.order(created_at: :desc).page(page).per(20)
  end
end
