module StaticHelper
	
	def title_helper(title)
		
		if title
			"Negotiations — #{title}"
		else
			"Negotations"
		end
		
	end
	
	def heading_helper(title)
		
		if title 
			title
		else
			"Negotiations"
		end
		
	end
	
end
