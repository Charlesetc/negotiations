class NegotiationsController < ApplicationController
	before_filter :signed_in_user
	before_filter :admin_user, except: :messages
	layout false, except: :new 
	
  def new
		@title = 'New Negotiation'
		@page_id = 'negotiation_creation'
		@negotiation = Negotiation.new
		@user = @negotiation # For error form
  end

  def create
		@negotiation = Negotiation.new(params[:negotiation])
		if @negotiation.save
			flash[:success] = 'You have successfully made a new Negotiation.'
			redirect_to root_url
		else
			@title = 'New Negotiation'
			@page_id = 'negotiation_creation'
			@user = @negotiation # For error form
			render 'new'
		end
  end

	def messages
		@negotiation = current_user.negotiation
	end
	
  def delete
		Negotiation.find(params[:id]).destroy
		render inline: 'Done'
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
		
end
