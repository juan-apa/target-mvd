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
  belongs_to :target_creator, class_name: 'Target'
  belongs_to :target_compatible, class_name: 'Target'
  belongs_to :conversation

  before_validation :create_conversation
  before_destroy :destroy_conversation

  scope :matches_with_targets, -> { joins(:target_creator, :target_compatible) }
  scope :compatible_and_same_creator,
        lambda {
          matches_with_targets
            .where(target_compatible: target_compatible,
                   targets: { user_id: target_creator.user.id })
        }
  scope :creator_same_as_compatible,
        lambda { |target_creator, target_compatible|
          matches_with_targets
            .where(target_creator: target_compatible,
                   targets: { user_id: target_compatible.user.id })
            .or(
              Match.matches_with_targets.where(target_compatible: target_compatible,
                                               targets: { user_id: target_creator.user.id })
            )
        }

  def create_conversation
    conversations = Match
                    .distinct.creator_same_as_compatible(target_creator, target_compatible)
                    .pluck(:conversation_id)
    self.conversation_id = conversations.empty? ? Conversation.create!.id : conversations[0]
  end

  def destroy_conversation
    matches_with_same_conversation = Match.where(conversation_id: conversation.id).count(:all)
    conversation.destroy! unless matches_with_same_conversation > 1
  end
end
