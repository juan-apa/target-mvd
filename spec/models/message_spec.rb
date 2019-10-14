require 'rails_helper'

describe Message do
  describe 'validations' do
    subject { build :message }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_inclusion_of(:read).in_array([true, false]) }
  end
end
