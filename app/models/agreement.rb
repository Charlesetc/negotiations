# == Schema Information
#
# Table name: agreements
#
#  id         :integer          not null, primary key
#  agree      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Agreement < ActiveRecord::Base
  attr_accessible :agree, :user_id
	validates :user_id, presence: true
	belongs_to :user
end
