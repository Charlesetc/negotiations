class SessionsController < ApplicationController
	
	
	def new
		@title = "Log In"
		@page_id = 'log_in'
	end
	
	def create
		user = User.find_by_email(params[:session][:email].downcase)
		
		if user && user.authenticate(params[:session][:password])
			sign_in user
			redirect_back_or user_path(user)
		else
			@title = "Log In"
			@page_id = 'log_in'
			flash.now[:warning] = 'Invalid Username/Password Combination'
			render 'new'
		end
	end
	
	def destroy
		sign_out
		redirect_to root_url
	end
	
	def english
		
		## Uncomment these lines to prevent users from changing locales
		
		#unless signed_in?
			#unless cookies[:locale]
				set_locale('en')
				#end
		#end
		redirect_to root_url
	end

	def hebrew
		
		## Uncomment these lines to prevent users from changing locales
		
		#unless signed_in?
			#unless cookies[:locale]
				set_locale('he')
				#end
		#end
		redirect_to root_url
	end
	
end
