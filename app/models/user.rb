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
#

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
	
	
	before_save { |user| user.email = email.downcase }
	before_save :create_remember_token
	
	VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
	VALID_USERNAME = /^\S*$/
	validates :name, presence: true
	validates :username, presence: true, uniqueness: true,
		 				length: { maximum: 50 }, format: {with: VALID_USERNAME}
	validates :email, presence: true, format: { with: VALID_EMAIL }, 
						uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }, confirmation: true
	validates :password_confirmation, presence: true
	validates :secure_key, presence: true
	validates :sex, presence: true
	validates :date_of_birth, presence: true
	validates :country, presence: true
	validates :start_english, presence: true, numericality: true
	validates :hebrew_listening, presence: true
	validates :hebrew_speaking, presence: true
	validates :hebrew_reading, presence: true
	validates :hebrew_writing, presence: true
	validates :english_listening, presence: true
	validates :english_speaking, presence: true
	validates :english_reading, presence: true
	validates :english_writing, presence: true
	validates :research, presence: true
	validates :emotions, presence: true
	
	def negotiation
		Negotiation.find_by_secure_key(self.secure_key)
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
	
	def other_user
		if self == self.negotiation.first_user
			return self.negotiation.second_user
		else
			return self.negotiation.first_user
		end
	end
	
	private
		
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
	
	
end
