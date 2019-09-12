require 'rails_helper'

describe User do
  describe 'validations' do
    subject { build :user }
    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(3).is_at_most(20) }
    # it { is_expected.to validate_length_of(:firstName).is_at_most(20) }

    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(3).is_at_most(20) }
    # it { is_expected.to validate_length_of(:lastName).is_at_most(20) }

    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(User.genders.keys) }
  end
end
