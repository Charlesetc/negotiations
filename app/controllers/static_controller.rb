class StaticController < ApplicationController
	
	
  def home
		unless signed_in?
			@page_id = 'home'
		else
			
			@user = current_user
			@negotiation = @user.negotiation			
			# @negotiation.randomize_if_new if @negotiation
			
			unless @user.admin
				unless @user.consent
					redirect_to consent_url and return
				end
				
				unless @user.background
					redirect_to background_url and return
				end
				
				unless @negotiation.user_background?
					redirect_to waiting_url and return
				end
				
				if @negotiation.thank_you?
					redirect_to thank_you_url and return
				end
				
				if @negotiation.agreed?
					redirect_to agreement_url and return
				end
			end
			
			params[:id] = current_user.id
			@page_id = "user_show"
			@body_id = 'show_body' unless current_user.admin
			@tabs = tabs
			render template: 'users/show'
			
		end
  end

  def search
  end

  def reference
		@title = 'Reference'
		@page_id = @title.downcase
  end

  def about
		@title = 'About'
		@page_id = @title.downcase
  end
end
