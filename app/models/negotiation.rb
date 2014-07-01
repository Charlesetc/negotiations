# == Schema Information
#
# Table name: negotiations
#
#  id         :integer          not null, primary key
#  secure_key :string(255)
#  language   :string(255)
#  prompt     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Negotiation < ActiveRecord::Base
  attr_accessible :language, :prompt, :secure_key
	
	validates :secure_key, presence: true
	
	
end
