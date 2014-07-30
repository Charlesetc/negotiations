# == Schema Information
#
# Table name: negotiations
#
#  id             :integer          not null, primary key
#  secure_key     :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  scenario_id    :integer
#  first_user_id  :integer
#  start_time     :datetime
#  end_time       :datetime
#  agreement_time :datetime
#


module CSVHelper
	
	def format_time(seconds)
		return false unless seconds
		seconds = seconds.to_i
		s = seconds % 60
		m = (seconds / 60) % 60
		h = seconds / 3600
		
		sprintf("%02d : %02d : %02d", h, m, s)
	end
	
	
end

class Negotiation < ActiveRecord::Base
  attr_accessible :secure_key, :scenario_id, :start_time, :end_time, :agreement_time
	
	validates :secure_key, presence: true, uniqueness: true
	validates :scenario_id, presence: true
	
	belongs_to :scenario
	has_many :messages
	
	include CSVHelper
	
	def self.array_header
		array = []
		array << "ID"
		array << "Scenario"
		array << "First User ID"
		array << "Second User ID"
		array << "Negotiation Time"
		array << "Agreement Time"
		array << "Total Time"
		array << "Language"
		array << "Current State"
		array << "Number of Users"
		array
	end
	
	def self.array_spacer
		array = []
		array << '-----------------'
		array << '-----------------'
		array << '-----------------'
		array << '-----------------'
		array << '-----------------'
		array << '-----------------'
		array << '-----------------'
		array << '-----------------'
		array << '-----------------'
		array << '-----------------'
		array
	end
	
	def make_array
		array = []
		array << self.id
		array << self.scenario.title
		array << self.first_user_id
		array << (self.second_user ? self.second_user.id : false)
		array << format_time(self.total_time)
		array << format_time(self.total_agreement_time)
		array << ((self.total_time && self.total_agreement_time) ? format_time(self.total_time + self.total_agreement_time) : false)
		array << self.language
		array << self.state
		array << self.users.count
		array
	end
	
	def full?
		self.users.count >= 2 # This is what designates negotiation size 
	end
	
	def agreed?
		self.first_user.agreed? && self.second_user.agreed?
	end
	
	def thank_you?
		if self.agreed?
			return self.first_user.agreement.description && self.second_user.agreement.description
		else
			false
		end
	end
	
	def total_agreement_time
		if self.end_time && self.agreement_time
			self.agreement_time - self.end_time
		else
			false
		end
	end
	
	def record_agreement_time
		self.agreement_time = Time.now
		self.save!
	end
	
	def state
		return 'empty' unless self.full?
		return 'thank_you' if self.thank_you?
		return 'agreed' if self.agreed?
		return 'ready' if self.ready?
		return 'background' if self.user_consent?
		'consenting'
	end
	
	def total_time
		if self.start_time && self.end_time
			self.end_time - self.start_time
		else
			false
		end
	end
	
	def time_left
		if self.start_time
			((20*60) - (Time.now - self.start_time)).round
		else
			(20*60)
		end
	end
	
	def user_background?
		return false unless self.full?
		return false unless self.first_user	&& self.second_user
		self.first_user.background && self.second_user.background
	end
	
	def user_consent?
		self.first_user.consent && self.second_user.consent
	end
	
	def users
		list = []
		User.all.each do |user|
			unless user.admin # Ignore admin's secure keys
				list << user if user.secure_key == self.secure_key
			end
		end
		list
	end
	
	def receiver(current_user)
		self.users.each do |user|
			unless user == current_user
				return user
			end
		end
		false
	end
	
	def first_user=(user)
		if user
			self.first_user_id = user.id
		else
			self.first_user_id = nil
		end
		self.save!
	end
	
	def second_user=(user)
		if user
			self.second_user_id = user.id
		else
			self.second_user_id = nil
		end
		self.save!
	end
	
	# def randomize_first_user
	# 	self.first_user = self.users.shuffle.first
	# end
	#
	# def randomize_if_new
	# 	unless self.first_user
	# 		randomize_first_user
	# 	end
	# end
	
	def ready?
		self.full? && self.first_user && self.user_consent? && self.user_background?
		# If this becomes a problem, just make it self.user_background?
	end
	
	def first_user
		User.find_by_id(self.first_user_id)
	end
	
	def second_user
		User.find_by_id(self.second_user_id)
	end
	
	def language
		self.scenario.language
	end
	
end
