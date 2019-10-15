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
#  index_matches_on_conversation_id                             (conversation_id)
#  index_matches_on_target_compatible_id                        (target_compatible_id)
#  index_matches_on_target_creator_id                           (target_creator_id)
#  index_matches_on_target_creator_id_and_target_compatible_id  (target_creator_id,target_compatible_id) UNIQUE
#  index_matches_on_user_compatible_id                          (user_compatible_id)
#  index_matches_on_user_creator_id                             (user_creator_id)
#

class Match < ApplicationRecord
  belongs_to :target_creator, class_name: 'Target', inverse_of: :matches_creators
  belongs_to :target_compatible, class_name: 'Target', inverse_of: :matches_compatible
  belongs_to :user_creator, class_name: 'User', inverse_of: :matches_creator
  belongs_to :user_compatible, class_name: 'User', inverse_of: :matches_compatible
  belongs_to :conversation, optional: true

  validate :same_user_creator_and_user_compatible
  validates :target_creator_id, uniqueness: { scope: :target_compatible_id }

  after_create :create_conversation
  before_destroy :destroy_conversation

  scope :matches_with_user_creator_or_compatible,
        lambda { |user|
          where(user_creator_id: user.id)
            .or(Match.distinct.where(user_compatible_id: user.id))
        }

  scope :user_matches, lambda { |user|
    where(user_creator_id: user.id)
      .or(Match.where(user_compatible_id: user.id))
  }

  delegate :opposite_user_unread_messages_count, :opposite_user_mark_messages_as_read!,
           to: :conversation

  def send_message_notification(user)
    if user_creator.id == user.id
      NotificationService.new_message_notification(user_compatible.notification_token)
    else
      NotificationService.new_message_notification(user_creator.notification_token)
    end
  end

  private

  def create_conversation
    conversations = Match.distinct
                         .matches_with_user_creator_or_compatible(target_creator.user)
                         .where.not(conversation: nil)
                         .pluck(:conversation_id)
    self.conversation_id = conversations.empty? ? Conversation.create!.id : conversations.first
    save!
  end

  def destroy_conversation
    matches_with_same_conversation = Match.where(conversation_id: conversation.id).count(:all)
    conversation.destroy! unless matches_with_same_conversation > 1
  end

  def same_user_creator_and_user_compatible
    return unless user_creator_id == user_compatible_id

    errors.add(:target, I18n.t('validation.errors.match_with_same_users'))
  end
end
