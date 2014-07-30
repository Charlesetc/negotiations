module UsersHelper

	def first_user?(user)
		user == user.negotiation.first_user
	end
	
	def language_string(array)
		out = ''
		array.each do |item|
			out << item.capitalize << ', '
		end
		out.gsub /, $/, ''
	end
	
	def online_users 
		online = []
		$redis.keys.each do |key|
			if key =~ /_last_seen$/
				user = User.find(key.sub(/_last_seen$/, ''))
				online << user if user.online?
			end
		end
		online
	end
	
	def online_admin
		admin = []
		online_users.each do |user|
			admin << user if user.admin
		end
		admin
	end
	

end
