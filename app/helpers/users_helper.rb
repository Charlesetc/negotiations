module UsersHelper

	def first_user?(user)
		user == user.negotiation.first_user
	end

end
