# == Schema Information
#
# Table name: agreements
#
#  id                :integer          not null, primary key
#  agree             :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer
#  agreement_boolean :boolean
#  price             :string(255)
#  description       :text
#

class Agreement < ActiveRecord::Base
  attr_accessible :agree, :user_id, :agreement_boolean, :price, :description
	validates :user_id, presence: true
	belongs_to :user
end


# Turn this agreement into an actual agreement!
# All validations are optional without presence: true
