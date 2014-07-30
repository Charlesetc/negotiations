require 'csv'

class UsersController < ApplicationController
	
	before_filter :signed_in_user, except: [:new, :create]
	before_filter :correct_user, only: [:show, :edit, :update, :accept_consent]
	before_filter :admin_user, only: [:toggle_admin, :delete, :index]
	layout false, only: :index
	
	
	def new
		if signed_in?
			flash[:error] = "You are already logged into an account."
			redirect_to root_url
		else
			@title = 'Sign Up'
			@page_id = 'sign_up'
			@user = User.new()
		end
 	end
	
	def show
		redirect_to root_url
	end
	
	def index
		@users = User.all
		respond_to do |format|
			format.csv {
				array = ['hi', 'there', 'finding', 'it', 'all', 'out']
				csv_string = CSV.generate do |csv|
					csv << User.array_header
					User.all.each do |user|
						unless user.admin
							csv << user.make_array
						end
					end
				end
				render inline: csv_string
			}
		end
	end
	
	def create
		@user = User.new(params[:user])
		@user.username.downcase
		@user.native_languages = 
			params[:user][:native_languages].gsub(/\s/, '').downcase.split(',')
		@user.foreign_languages = 
			params[:user][:foreign_languages].gsub(/\s/, '').downcase.split(',')
			

		if @neg = Negotiation.find_by_secure_key(@user.secure_key) 
			unless @neg.full?
				if @user.save
					sign_in @user
					flash[:success] = 'Welcome'
					redirect_to instructions_url
				else
					@title = 'Sign Up'
					@page_id = "sign_up"
					render 'new'
				end
			else
				@title = 'Sign Up'
				@page_id = 'sign_up'
				flash.now[:error] = 'That secure key has already been used.'
				render 'new'
			end
		else
			@title = 'Sign Up'
			@page_id = "sign_up"
			flash.now[:error] = 'You do not have a valid secure key'
			render 'new'
		end
		
	end
	
	def last_seen
		$redis.set "#{current_user.id}_last_seen", Time.now.to_i if current_user
		render inline: 'Done'
	end
	
	def accept_consent
		@user = User.find(params[:id])
		@user.update_attribute(:start_background, Time.now) unless @user.start_background
		@user.update_attribute(:consent, true)
		sign_in @user # Very important, update attributes changes.
		render inline: "Done"
	end
	
	def accept_background
		PrivatePub.publish_to "/negotiation/waiting/#{current_user.negotiation.id}", :content => true 
		@user = current_user
		@user.update_attribute(:end_background, Time.now) unless @user.end_background
		@user.update_attribute(:background, true)
		if @user.negotiation.user_background?
			@user.negotiation.update_attribute :start_time, Time.now unless @user.negotiation.start_time
		end
		sign_in @user
		redirect_to root_url
	end
	
	def alert_request
		PrivatePub.publish_to "/negotiation/#{current_user.negotiation.id}/new", 
			alert_request: true,
			user_id: current_user.id
		render inline: 'Done'
	end
	
	def accept_alert_request
		if params[:tactic] == 'accept'
		
			@negotiation = current_user.negotiation
			
			@negotiation.end_time = Time.now
			@negotiation.save!
			
			@negotiation.users.each do |user|
				user.make_agree
			end
			
			# Has to be before the publish, because otherwise
			# publish could take users to page before page is
			# accessible.
			
			PrivatePub.publish_to "/negotiation/#{current_user.negotiation.id}/new",
				accept_alert_request: true		
				
			render inline: 'Done'
		else
			PrivatePub.publish_to "/negotiation/#{current_user.negotiation.id}/new",
				deny_alert_request: true,
				user_id: current_user.id
		end
	end
	
	def agreement
		if current_user.negotiation.agreed?
			@title = 'Agreement'
			@page_id = 'agreement_page'
			@body_id = 'user_show' # For no scrolling
		else
			redirect_to root_url
		end
	end
	
	def consent
		@title = 'Consent'
		@page_id = 'consent_page'
	end
	
	def agree_channel
		PrivatePub.publish_to "/#{current_user.negotiation.id}/agree", params
			
		render inline: 'Done'
	end
	
	def finish_agreement
		@agreement = current_user.agreement
		@negotiation = current_user.negotiation
		@agreement.agreement_boolean = params[:agreement_boolean]
		@agreement.price = params[:price]
		@agreement.description = params[:description]
		@agreement.save!
		
		@negotiation.record_agreement_time unless @negotiation.agreement_time
		
		render inline: 'Done'
	end
	
	def thank_you
		if current_user.negotiation.thank_you?
			@title = 'Thank You!'
			@page_id = 'thank_you_page'
		else
			redirect_to root_url
		end
	end
	
	def background
		@title = 'Background'
		@page_id = 'background_page'
	end
	
	def waiting
		@title = 'Waiting'
		@page_id = 'waiting_page'
	end
	
	def instructions
		@title = 'Instructions'
		@page_id = 'instructions_page'
	end
	
	def edit
		@title = 'Settings'
		@page_id = 'settings'
		@user = User.find(params[:id])
	end
	
	def update
		@user = User.find(params[:id])
		# @attributes = params[:user]
		# @attributes[:secure_key] = @user.secure_key
		#
		# @attributes[:native_languages] =
		# 	params[:user][:native_languages].gsub(/ /, '').downcase.split(',')
		# @attributes[:foreign_languages] =
		# 	params[:user][:foreign_languages].gsub(/ /, '').downcase.split(',')
		@attributes = params[:user]
		
		@user.username = @attributes[:username]
		@user.password = @attributes[:new_password]
		@user.password_confirmation = @attributes[:password_confirmation]
		@user.name = @attributes[:name]
		@user.email = @attributes[:email]
		
		if @user.save
			
			flash[:success] = 'You have succcessfully updated your settings.'
			sign_in @user
			redirect_to root_url
			
		else
			@title = 'Settings'
			@page_id = 'settings'
			render 'edit'
		end
		
	end
	
	def delete
		User.find(params[:id]).destroy
		render inline: 'Done'
	end
	
	def toggle_admin
		@user = User.find(params[:id])
		if @user.admin
			@user.update_attribute(:admin, false)
		else
			@user.update_attribute(:admin, true)
		end
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
		
		def correct_user
			@user = User.find(params[:id])
			unless current_user?(@user)
				redirect_to root_url
				flash[:error] = 'You do not have permission to access that page.'
			end
		end
end
