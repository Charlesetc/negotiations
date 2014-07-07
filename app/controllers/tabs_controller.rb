class TabsController < ApplicationController
	
	before_filter :signed_in_user
	before_filter :correct_user, except: :private_pub_subscribe
	before_filter :admin_user, only: :admin
	layout false
	
 	def admin
 	end
 	
 	def background
 	end
 	
 	def negotiation
		@negotiation = current_user.negotiation
 	end
 	
 	def supervisor
 	end
	
	def private_pub_subscribe
		respond_to do |format|
		    format.js
		  end
	end
  
 	private 
		def signed_in_user
			unless signed_in?
				store_location
				redirect_to log_in_url
				flash[:error] = 'Please Sign In'
			end
		end
    	
		def admin_user
			unless current_user.admin
				redirect_to root_url
				flash[:error] = 'You do not have permission to access that page.'
			end
		end
		
		def correct_user
			@user = User.find(params[:id])
			unless current_user?(@user)
				redirect_to root_url
				flash[:error] = 'You do not have permission to access that page.'
			end
		end
	
end
