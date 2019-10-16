# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  conversation_id :integer
#  body            :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  read            :boolean          default(FALSE), not null
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_user_id          (user_id)
#

require 'rails_helper'

describe Message do
  describe 'validations' do
    subject { build :message }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_inclusion_of(:read).in_array([true, false]) }
  end
end
