# == Schema Information
#
# Table name: matches
#
#  id                   :integer          not null, primary key
#  target_creator_id    :integer
#  target_compatible_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  conversation_id      :integer
#
# Indexes
#
#  index_matches_on_conversation_id       (conversation_id)
#  index_matches_on_target_compatible_id  (target_compatible_id)
#  index_matches_on_target_creator_id     (target_creator_id)
#

class Match < ApplicationRecord
  belongs_to :target_creator, :class_name => 'Target'
  belongs_to :target_compatible, :class_name => 'Target'
  belongs_to :conversation

  before_validation :create_conversation
  after_destroy :destroy_conversation

  private

  def create_conversation
    matches = Match.joins(:target_creator, :target_compatible).where(target_compatible: target_compatible, targets: {user_id: target_creator.user.id})
          .or(Match.joins(:target_creator, :target_compatible).where(target_creator: target_compatible, targets: {user_id: target_compatible.user.id}))

    self.conversation = matches.empty? ? Conversation.create! : matches[0].conversation
  end

  def destroy_conversation
    matches_with_same_conversation = Matches.count(:all).where(conversation: conversation)
    conversation.destroy! unless matches_with_same_conversation > 1
  end
end
