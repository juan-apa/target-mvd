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

require 'rails_helper'

describe Match do
  describe 'validations' do
    subject { build :match }
    it do
      is_expected.to validate_uniqueness_of(:target_creator_id).scoped_to(:target_compatible_id)
    end

    context do
      let!(:user) { create :user }
      before do
        subject.user_creator = user
        subject.user_compatible = user
      end

      it { is_expected.not_to be_valid }
    end
  end

  describe 'other_user_unread_messages' do
    let!(:match) { create :match }
    let!(:user_creator_messages) do
      create_list :message,
                  5,
                  read: false,
                  user: match.user_creator,
                  conversation: match.conversation
    end

    it 'returns 0 for the user who sent the messages' do
      expect(match.opposite_user_unread_messages_count(match.user_creator)).to eql(0)
    end

    it 'returns the amount of the created messages for the other user' do
      expect(match.opposite_user_unread_messages_count(match.user_compatible))
        .to eq(user_creator_messages.length)
    end
  end
end
