# == Schema Information
#
# Table name: scenarios
#
#  id                :integer          not null, primary key
#  general           :text
#  first_role        :text
#  second_role       :text
#  title             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language          :string(255)
#  first_role_title  :string(255)
#  second_role_title :string(255)
#

class Scenario < ActiveRecord::Base
  attr_accessible :first_role, :general, :second_role, :title
	attr_accessible :language, :first_role_title, :second_role_title
	
	has_many :negotiations # , dependent: :delete
												 # See if this works later
												 # Or implement it myself 
	
	validates :title, presence: true
	validates :language, presence: true
	
	def self.select_list
		out = []
		self.all.each do |scenario|
			out << [scenario.title, scenario.id]
		end
		out
	end
	
end
