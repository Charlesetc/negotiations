# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string(255)
#  name              :string(255)
#  email             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string(255)
#  remember_token    :string(255)
#  sex               :string(255)
#  secure_key        :string(255)
#  native_languages  :text
#  foreign_languages :text
#  admin             :boolean          default(FALSE)
#  consent           :boolean          default(FALSE)
#  background        :boolean          default(FALSE)
#  start_background  :datetime
#  end_background    :datetime
#  date_of_birth     :date
#  country           :string(255)
#  start_english     :integer
#  english_home      :boolean
#  acquired_english  :text
#  hebrew_listening  :integer
#  hebrew_speaking   :integer
#  hebrew_reading    :integer
#  hebrew_writing    :integer
#  english_listening :integer
#  english_speaking  :integer
#  english_reading   :integer
#  english_writing   :integer
#  emotions          :text
#  research          :text
#  subject_number    :integer
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

class User < ActiveRecord::Base

	attr_accessible :email, :name, :username, :password, :new_password, :password_confirmation
	attr_accessible :sex, :date_of_birth, :secure_key, :foreign_languages, :native_languages
	attr_accessible :admin, :consent, :background, :start_background, :end_background
	attr_accessible :country, :start_english, :english_home, :acquired_english
	attr_accessible :hebrew_listening, :hebrew_speaking, :hebrew_reading, :hebrew_writing
	attr_accessible :english_listening, :english_speaking, :english_reading, :english_writing
	attr_accessible :research, :emotions
																		# These might be unnecessary
	serialize :native_languages, Array
	serialize :foreign_languages, Array
	serialize :acquired_english, Array
	
	has_secure_password
	
	has_many :agreements
	
	before_save { |user| user.email = email.downcase }
	before_save :create_remember_token
	
	VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
	VALID_USERNAME = /^\S*$/
	validates :name, presence: true	
	# validates :username, presence: true, uniqueness: true,
	# 	 				length: { maximum: 50 }, format: {with: VALID_USERNAME}
	validates :email, presence: true, format: { with: VALID_EMAIL }, 
						uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }, confirmation: true
	validates :password_confirmation, presence: true
	validates :secure_key, presence: true
	validates :sex, presence: true
	validates :date_of_birth, presence: true
	validates :country, presence: true
	validates :research, presence: true
	# validates :start_english, presence: true, numericality: true
	# validates :hebrew_listening, presence: true  # Add these for actual study.
	# validates :hebrew_speaking, presence: true   # Add these for actual study.
	# validates :hebrew_reading, presence: true    # Add these for actual study.
	# validates :hebrew_writing, presence: true    # Add these for actual study.
	# validates :english_listening, presence: true # Add these for actual study.
	# validates :english_speaking, presence: true  # Add these for actual study.
	# validates :english_reading, presence: true   # Add these for actual study.
	# validates :english_writing, presence: true   # Add these for actual study.
	# validates :english_home, presence: true      # Add these for actual study.
	#validates :emotions, presence: true           # Add these for actual study.
	
	
	include CSVHelper
	
	def to_h
		JSON.parse(self.to_json)
	end
	
	def self.array_header
		array = []
		array << 'Subject Number'
		array << 'Sex'
		array << 'Date of Birth'
		array << 'Age'
		array << 'Background Time'
		array << 'English Acquisition'
		array << 'English Starting Age'
		array << 'English Spoken at Home'
		array << 'Country'
		array << 'Hebrew Listening'
		array << 'Hebrew Speaking'
		array << 'Hebrew Reading'
		array << 'Hebrew Writing'
		array << 'English Listening'
		array << 'English Speaking'
		array << 'English Reading'
		array << 'English Writing'
		array << 'Emotions'
		array << 'Knowlege of Research'
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
		array << self.subject_number
		array << self.sex
		array << self.date_of_birth.strftime("%m/%d/%y")
		array << self.age
		array << format_time(self.background_time)
		array << self.acquired_english
		array << self.start_english
		array << self.english_home
		array << self.country
		array << self.hebrew_listening
		array << self.hebrew_speaking
		array << self.hebrew_reading
		array << self.hebrew_writing
		array << self.english_listening
		array << self.english_speaking
		array << self.english_reading
		array << self.english_writing
		array << self.emotions
		array << self.research
		array
	end
	
	def age
	  now = Time.now.utc.to_date
	  now.year - date_of_birth.year - (date_of_birth.to_date.change(:year => now.year) > now ? 1 : 0)
	end
	
	def negotiation
		Negotiation.find_by_secure_key(self.secure_key)
	end
	
	def set_role_if_not_yet_set
		@negotiation = self.negotiation
		if @negotiation.first_user
			if @negotiation.second_user
				return 'false'
			else
				@negotiation.second_user = self
			end
		else
			if @negotiation.second_user
				@negotiation.first_user = self
			else
				if Random.rand() > 0.5
					@negotiation.first_user = self
				else
					@negotiation.second_user = self
				end
			end
		end
	end
	
	def agreement
		self.agreements[0]
	end
	
	def online?
		time = $redis.get "#{self.id}_last_seen"
		difference = Time.now.to_i - time.to_i
		difference <= 30
	end
	
	def background_time
		return false unless self.start_background && self.end_background
		self.end_background - self.start_background
	end
	
	def role
		if self == self.negotiation.first_user
			return self.scenario.first_role_title
		else
			return self.scenario.second_role_title
		end
	end
	
	def scenario
		self.negotiation.scenario
	end
	
	def agreed?
		self.agreements.length > 0
	end
	
	def make_agree
		self.agreements.create!
	end
	
	def other_user
		if self == self.negotiation.first_user
			return self.negotiation.second_user
		else
			return self.negotiation.first_user
		end
	end
	
	def return_acquisition(string, other = false)
		if other
			'other'
		else
			'notother'
		end
	end
	
	private
		
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
	
	
end
