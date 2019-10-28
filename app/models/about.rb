# == Schema Information
#
# Table name: abouts
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class About < ApplicationRecord
  validates :content, presence: true
end
