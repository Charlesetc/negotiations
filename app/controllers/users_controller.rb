class UsersController < ApplicationController
	
	before_filter :signed_in_user, only: [:edit, :update]
	before_filter :correct_user, only: [:edit, :update]
	
	
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
		@user = User.find(params[:id])
		@title = @user.title
		@page_id = "user_show"
	end
	
	def create
		@user = User.new(params[:user])
		@user.username.downcase
		
		if @user.save
			sign_in @user
			flash[:success] = 'Welcome to Maylogs!'
			redirect_to @user
		else
			@page_id = "sign_up"
			render 'new'
		end
		
	end
	
	def edit
		@title = 'Settings'
		@page_id = 'settings'
		@user = User.find(params[:id])
	end
	
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = 'You have succcessfully changed your identity.'
			sign_in @user
			redirect_to @user
		else
			render 'edit'
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
		
		def correct_user
			@user = User.find(params[:id])
			unless current_user?(@user)
				redirect_to root_url
				flash[:error] = 'You do not have permission to access that page.'
			end
		end
end
