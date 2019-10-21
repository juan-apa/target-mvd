# == Schema Information
#
# Table name: abouts
#
#  id         :integer          not null, primary key
#  about      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class About < ApplicationRecord
  validates :about, presence: true
end
