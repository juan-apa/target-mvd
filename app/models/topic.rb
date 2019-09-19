# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Topic < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 40 }, uniqueness: true
end
