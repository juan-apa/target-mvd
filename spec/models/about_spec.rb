require 'rails_helper'

describe About do
  describe 'validations' do
    subject { build :about }
    it { is_expected.to validate_presence_of(:about) }
  end
end
