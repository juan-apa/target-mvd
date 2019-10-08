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
  MAX_NUMBER_OF_TARGETS = ENV.fetch('MAX_NUMBER_OF_TARGETS').to_i

  acts_as_mappable lat_column_name: :latitude,
                   lng_column_name: :longitude

  belongs_to :topic
  belongs_to :user

  delegate :notification_token, to: :user, prefix: true

  validates :title, presence: true, length: { minimum: 3, maximum: 40 }
  validates :radius, presence: true, numericality: { less_than_or_equal_to: 999,
                                                     greater_than_or_equal_to: 1 }
  validate :validate_target_limit, on: :create

  after_create :create_matches

  scope :matching_targets, lambda { |target|
    within(target.radius, units: :meters, origin: [target.latitude, target.longitude])
      .where(topic_id: target.topic.id)
      .where.not(user_id: target.user.id)
  }

  private

  def validate_target_limit
    return unless user.targets.size >= MAX_NUMBER_OF_TARGETS

    errors.add(:target, I18n.t('validation.errors.targets_limit_reached'))
  end

  def create_matches
    Target.matching_targets(self).each do |target|
      NotificationService
        .create_notification([target.user_notification_token, user_notification_token])
    end
  end
end
