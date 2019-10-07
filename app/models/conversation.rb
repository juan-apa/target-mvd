# == Schema Information
#
# Table name: conversations
#
#  id :integer          not null, primary key
#

class Conversation < ApplicationRecord
  has_many :matches, dependent: :delete_all
  has_many :messages, dependent: :destroy
end
