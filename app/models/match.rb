# == Schema Information
#
# Table name: matches
#
#  id          :integer          not null, primary key
#  target_1_id :integer
#  target_2_id :integer
#
# Indexes
#
#  index_matches_on_target_1_id  (target_1_id)
#  index_matches_on_target_2_id  (target_2_id)
#

class Match < ApplicationRecord
  belongs_to :target_1, class_name: 'Target'
  belongs_to :target_2, class_name: 'Target'
end
