require 'rails_helper'

describe User do
  describe 'validations' do
    subject { build :user }
    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to validate_presence_of(:firstName) }
    it { is_expected.to validate_length_of(:firstName).is_at_least(3) }
    it { is_expected.to validate_length_of(:firstName).is_at_most(20) }

    it { is_expected.to validate_presence_of(:lastName) }
    it { is_expected.to validate_length_of(:lastName).is_at_least(3) }
    it { is_expected.to validate_length_of(:lastName).is_at_most(20) }

    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(User.genders.keys) }
  end
end
