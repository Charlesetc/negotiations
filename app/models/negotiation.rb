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
#  second_user_id :integer
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
		array << "First Agree Goals"
		array << "First Agree Yes/No"
		array << "First Agree Description"
		array << "First Agree Price"
		array << "Second Agree Goals"
		array << "Second Agree Yes/No"
		array << "Second Agree Description"
		array << "Second Agree Price"
		array
	end

	def first_user_goals
		[["Promotion", "You absolutely need to reach an agreement to receiver your promotion."], ["Price", "You absolutely cannot pay more than $500,000 for the station itself."]]
	end

	def second_user_goals
		[['Boat Trip', "You absoutely need to at least $420,000 to go on your boat trip."], ['Living Costs', "You estimate you need a minumum of $75,000 to live on after you return from your trip."]]
	end

	def self.array_spacer
		array = []
		18.times do
			array << '-----------------'
		end
		array
	end

	def make_array
		array = []
		array << self.id
		array << self.scenario.title
		array << (self.first_user ? self.first_user.subject_number : false)
		array << (self.second_user ? self.second_user.subject_number : false)
		array << format_time(self.total_time)
		array << format_time(self.total_agreement_time)
		array << ((self.total_time && self.total_agreement_time) ? format_time(self.total_time + self.total_agreement_time) : false)
		array << self.language
		array << self.state
		array << self.users.count
		if self.first_user && self.first_user.agreement && self.first_user.agreement.description
			array << self.first_user.chosen_goals_or_string
			array << self.first_user.agreement.agreement_boolean
			array << self.first_user.agreement.price
			array << self.first_user.agreement.description
		else
			4.times do
				array << false
			end
		end
		if self.second_user && self.second_user.agreement && self.second_user.agreement.description
			array << self.second_user.chosen_goals_or_string
			array << self.second_user.agreement.agreement_boolean
			array << self.second_user.agreement.price
			array << self.second_user.agreement.description
		else
			4.times do
				array << false
			end
		end
		array
	end

	def full?
		self.users.count >= 2 # This is what designates negotiation size
	end

	def agreed?
		if self.first_user && self.second_user
			self.first_user.agreed? && self.second_user.agreed?
		else
			false
		end
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

	def first_end_time
		if self.start_time
			(self.start_time + (20*60)).to_i * 1000
		else
			3
		end
	end
	#
	# def first_end_seconds
	# 	if self.start_time
	# 		return (self.start_time + (20 * 60)).sec
	# 	else
	# 		3
	# 	end
	# end
	#
	# def first_end_minutes
	# 	if self.start_time
	# 		return (self.start_time + (20 * 60)).min
	# 	else
	# 		3
	# 	end
	# end

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

	def time_spent
		Time.now - self.start_time
	end

	def time_color
		if self.start_time
			if time_spent < (20*60)
				return 'white'
			elsif time_spent > (30*60)
				return 'red'
			else
				return '#3388FF'
			end
		else
			return 'white'
		end
	end

	def time_left
		if self.start_time
			if time_spent < (20*60)
				return ((20*60) - time_spent).round
			else
				return ((10*60) - time_spent).round
			end
		else
			return (20*60)
		end
	end

	def user_background?
		return false unless self.full?
		return false unless self.first_user	&& self.second_user
		self.first_user.background && self.second_user.background
	end

	def user_consent?
		if self.first_user && self.second_user
			self.first_user.consent && self.second_user.consent
		else
			false
		end
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
