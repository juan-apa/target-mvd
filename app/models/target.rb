# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  title      :string
#  radius     :integer
#  latitude   :decimal(10, 6)
#  longitude  :decimal(10, 6)
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
  belongs_to :topic
  belongs_to :user
  validates :title, null: false, length: { minimum: 3, maximum: 40 }
  validates :radius, null: false, length: { minimum: 1, maximum: 3, numericality: true }
  acts_as_mappable lat_column_name: :latitude,
                   lng_column_name: :longitude
end
