# == Schema Information
#
# Table name: matches
#
#  id                   :integer          not null, primary key
#  target_creator_id    :integer
#  target_compatible_id :integer
#  user_creator_id      :integer
#  user_compatible_id   :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  conversation_id      :integer
#
# Indexes
#
#  index_matches_on_conversation_id       (conversation_id)
#  index_matches_on_target_compatible_id  (target_compatible_id)
#  index_matches_on_target_creator_id     (target_creator_id)
#  index_matches_on_user_compatible_id    (user_compatible_id)
#  index_matches_on_user_creator_id       (user_creator_id)
#

class Match < ApplicationRecord
  belongs_to :target_creator, class_name: 'Target', inverse_of: :matches_creators
  belongs_to :target_compatible, class_name: 'Target', inverse_of: :matches_compatible
  belongs_to :user_creator, class_name: 'User', inverse_of: :matches_creator
  belongs_to :user_compatible, class_name: 'User', inverse_of: :matches_compatible
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

  private

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
