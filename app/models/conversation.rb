# == Schema Information
#
# Table name: conversations
#
#  id :integer          not null, primary key
#

class Conversation < ApplicationRecord
  has_many :matches, dependent: nil
  has_many :messages, dependent: :destroy
end