# == Schema Information
#
# Table name: abouts
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe About do
  describe 'validations' do
    subject { build :about }
    it { is_expected.to validate_presence_of(:content) }
  end
end
