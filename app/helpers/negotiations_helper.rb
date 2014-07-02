module NegotiationsHelper
	
	def generate_secure_key(length = 20)
		choices = [*('a'..'z'), *('0'..'9')]
		out = ''
		length.times do 
			out << choices.shuffle.first
		end
		out
	end
	
	
end
