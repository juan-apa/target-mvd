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

FactoryBot.define do
  factory :match do
    target_creator { create :target }
    target_compatible { create :target }
    user_creator { target_creator.user }
    user_compatible { target_compatible.user }
    conversation
  end
end
