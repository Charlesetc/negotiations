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

end
