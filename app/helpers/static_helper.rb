module StaticHelper
	
	def title_helper(title)
		
		if title
			"Maylogs — #{title}"
		else
			"Maylogs"
		end
		
	end
	
	def heading_helper(title)
		
		if title 
			title
		else
			"Maylogs"
		end
		
	end
	
end
