module TabsHelper
	
	def admin_tabs
		[
			build_tab('', 'Admin'),
			build_tab('', 'Supervisor'),
		]
	end
	
	def user_tabs
		[
			build_tab('', 'Background'),
			build_tab('', 'Negotiation'),
			build_tab('', 'Supervisor'),
		]
	end
	
	def build_tab(content, title)
		{content: content, title: title}
	end
	
	def tabs
		if current_user.admin
			admin_tabs
		else
			user_tabs
		end
	end
	
	
end
