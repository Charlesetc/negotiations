module UsersHelper

	def tabs
		tabs = []
		Dir.entries(Rails.root + "app/views/tabs").each do |file|
			unless file == '.' or file == '..'
				content = `erb #{Rails.root + 'app/views/tabs/' + file}`
				title = file.sub /\.html\.erb$/, ''
				tabs << build_tab(content.html_safe, title.capitalize)
			end
		end
		tabs
	end
	
	
	def build_tab(content, title)
		{content: content, title: title}
	end
	
end
