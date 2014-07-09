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
#  age               :integer
#  secure_key        :string(255)
#  native_languages  :text
#  foreign_languages :text
#  admin             :boolean          default(FALSE)
#

class User < ActiveRecord::Base

	attr_accessible :email, :name, :username, :password, :password_confirmation
	attr_accessible :sex, :age, :secure_key, :foreign_languages, :native_languages
	attr_accessible :admin
	
	serialize :native_languages, Array
	serialize :foreign_languages, Array
	
	has_secure_password
	
	
	before_save { |user| user.email = email.downcase }
	before_save :create_remember_token
	
	VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
	VALID_USERNAME = /^\S*$/
	VALID_AGE = /^(\n)$/
	validates :name, presence: true
	validates :username, presence: true, uniqueness: true,
		 				length: { maximum: 50 }, format: {with: VALID_USERNAME}
	validates :email, presence: true, format: { with: VALID_EMAIL }, 
						uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }, confirmation: true
	validates :password_confirmation, presence: true
	validates :secure_key, presence: true
	validates :sex, presence: true
	validates :age, presence: true, numericality: { only_integer: true, less_than: 110 }
	
	
	def negotiation
		Negotiation.find_by_secure_key(self.secure_key)
	end
	
	def online?
		time = $redis.get "#{self.id}_last_seen"
		difference = Time.now.to_i - time.to_i
		difference <= 30
	end
	
	
	private
		
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
	
	
end
