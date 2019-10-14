require 'rails_helper'

describe Message do
  describe 'validations' do
    subject { build :message }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:read) }
  end
end
