# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  title      :string(40)       not null
#  radius     :integer          not null
#  latitude   :decimal(10, 6)   not null
#  longitude  :decimal(10, 6)   not null
#  user_id    :integer
#  topic_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_targets_on_latitude_and_longitude  (latitude,longitude)
#  index_targets_on_topic_id                (topic_id)
#  index_targets_on_user_id                 (user_id)
#

require 'rails_helper'

describe Target do
  describe 'validations' do
    subject { build :target }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:radius) }
    it {
      is_expected.to validate_numericality_of(:radius)
        .is_greater_than_or_equal_to(1)
        .is_less_than_or_equal_to(999)
    }
  end

  describe 'create' do
    let!(:user_1) { create :user }
    let!(:user_2) { create :user }
    let!(:target_1) { create :target, user: user_1 }

    context 'matching target' do
      it 'creates a match and a conversation' do
        expect {
          create :target,
                 latitude: target_1.latitude,
                 longitude: target_1.longitude,
                 topic: target_1.topic,
                 user: user_2
        }.to change { [Target.count, Match.count, Conversation.count] }
          .from([1, 0, 0])
          .to([2, 1, 1])
      end

      it 'sends a notification to both target\'s users' do
        allow(NotificationService).to receive(:create_notification)
      end
    end

    context 'non-matching target' do
      it 'doesn\'t create a match and a conversation' do
        expect {
          create :target,
                 latitude: target_1.latitude,
                 longitude: target_1.longitude,
                 user: user_2
        }.to change { [Target.count, Match.count, Conversation.count] }
          .from([1, 0, 0])
          .to([2, 0, 0])
      end
    end

    context 'target that has already a match with the same user' do
      let!(:target_2) do
        create :target,
               latitude: target_1.latitude,
               longitude: target_1.longitude,
               topic: target_1.topic,
               user: user_2
      end

      it 'creates a match with the same conversation as the previous match' do
        expect {
          create :target,
                 latitude: target_1.latitude,
                 longitude: target_1.longitude,
                 topic: target_1.topic,
                 user: user_2
        }.to change { [Target.count, Match.count, Conversation.count] }
          .from([2, 1, 1])
          .to([3, 2, 1])
      end
    end
  end

  describe 'destroy' do
    let!(:user_1) { create :user }
    let!(:user_2) { create :user }
    let!(:target_1) { create :target, user: user_1 }

    context 'matching target' do
      let!(:target_2) do
        create :target,
               latitude: target_1.latitude,
               longitude: target_1.longitude,
               topic: target_1.topic,
               user: user_2
      end

      it 'deletes the target, the match and the conversation' do
        expect {
          target_2.destroy!
        }.to change { [Target.count, Match.count, Conversation.count] }
          .from([2, 1, 1])
          .to([1, 0, 0])
      end
    end

    context 'target that has multiple matches with the same person' do
      let!(:target_2) do
        create :target,
               latitude: target_1.latitude,
               longitude: target_1.longitude,
               topic: target_1.topic,
               user: user_2
      end
      let!(:target_3) do
        create :target,
               latitude: target_1.latitude,
               longitude: target_1.longitude,
               topic: target_1.topic,
               user: user_2
      end

      it 'deletes the target and the match, but keeps the conversation' do
        expect {
          target_3.destroy!
        }.to change { [Target.count, Match.count, Conversation.count] }
          .from([3, 2, 1])
          .to([2, 1, 1])
      end
    end
  end

  describe 'validate_target_limit' do
    let!(:user) { create :user }
    let!(:targets) { create_list :target, 10, user: user }
    let(:new_target) { build :target, user: user }

    it 'doesn\'t insert new target to user' do
      user.reload
      expect {
        new_target.save
      }.not_to change(Target, :count)
    end

    it 'returns an error message' do
      user.reload
      expect { new_target.save! }.to raise_error(ActiveRecord::RecordInvalid)
        .with_message('Validation failed: Target ' +
          I18n.t('validation.errors.targets_limit_reached'))
    end
  end
end
