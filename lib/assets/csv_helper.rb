
module CSVHelper
	
	def format_time(seconds)
		s = seconds % 60
		m = (seconds / 60) % 60
		h = seconds / 3600
		
		format("%02d:%02d:%02d", h, m, s) 
	end
	
	
end