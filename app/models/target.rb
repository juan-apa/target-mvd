# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  title      :string(40)       not null
#  radius     :integer          not null
#  latitude   :decimal(10, 6)   not null
#  longitude  :decimal(10, 6)   not null
#  user_id    :integer
#  topic_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_targets_on_latitude_and_longitude  (latitude,longitude)
#  index_targets_on_topic_id                (topic_id)
#  index_targets_on_user_id                 (user_id)
#

class Target < ApplicationRecord
  MAX_NUMBER_OF_TARGETS = 10

  acts_as_mappable lat_column_name: :latitude,
                   lng_column_name: :longitude

  belongs_to :topic
  belongs_to :user

  validates :title, presence: true, length: { minimum: 3, maximum: 40 }
  validates :radius, presence: true, numericality: { less_than_or_equal_to: 999,
                                                     greater_than_or_equal_to: 1 }
  validate :validate_target_limit, on: :create

  private

  def validate_target_limit
    return unless user.targets.size >= MAX_NUMBER_OF_TARGETS

    errors.add(:target, I18n.t('validation.errors.targets_limit_reached'))
  end
end
