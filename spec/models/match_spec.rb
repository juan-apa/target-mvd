require 'rails_helper'

describe Match do
  describe 'validations' do
    subject { build :match }
    it { is_expected.to validate_uniqueness_of(:target_creator_id).scoped_to(:target_compatible_id) }

    context do
      let!(:user) { create :user }
      before do
        subject.user_creator = user
        subject.user_compatible = user
      end

      it { is_expected.not_to be_valid }
    end
  end
end
