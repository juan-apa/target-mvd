# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           not null
#  gender                 :string           not null
#  first_name             :string           not null
#  last_name              :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  tokens                 :json
#  notification_token     :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

require 'rails_helper'

describe User do
  describe 'validations' do
    subject { build :user }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(3).is_at_most(20) }

    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(3).is_at_most(20) }

    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(User.genders.keys) }
  end
end
