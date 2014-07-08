module NegotiationsHelper
	
	def generate_secure_key(length = 10)
		choices = [*('0'..'9')]
		out = ''
		length.times do 
			out << choices.shuffle.first
		end
		out
	end
	
	def list_user_id(negotiation)
		list = []
		negotiation.users.each do |user|
			list << user.id
		end
		list.inspect
	end
	
	
end
