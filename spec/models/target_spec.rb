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
      expected_error_message = 'Validation failed: Target you have reached \
                                 the maximum number of targets'
      expect { new_target.save! }.to raise_error(ActiveRecord::RecordInvalid)
        .with_message(expected_error_message)
    end
  end
end
