class NegotiationsController < ApplicationController
	before_filter :signed_in_user, except: :secure_key_validation
	before_filter :admin_user, except: [:form, :secure_key_validation]
	layout false, except: [:new, :inspect, :form, :secure_key_validation] 

	
  def new
		@title = 'New Negotiation'
		@page_id = 'negotiation_creation'
		@negotiation = Negotiation.new
		@user = @negotiation # For error form
  end
	
	def index
		respond_to do |format|
			format.csv {
				csv_string = CSV.generate do |csv|
					csv << Negotiation.array_header
					csv << Negotiation.array_spacer
					Negotiation.all.each do |negotiation|
						csv << negotiation.make_array
					end
				end
				render inline: csv_string
			}
		end
	end
	
	def secure_key_validation
		@title = 'Sign Up'
		@page_id = 'secure_key_validation'
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
	
	def inspect
		@negotiation = Negotiation.find(params[:id])
		@title = 'Negotiation History'
		@page_id = 'negotiation_inspection'
	end
	
	def messages
		@negotiation = current_user.negotiation
	end # Might have trouble here
	
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
