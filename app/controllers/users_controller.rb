class UsersController < ApplicationController
	
	before_filter :signed_in_user, except: [:new, :create]
	before_filter :correct_user, except: [:new, :create, :toggle_admin, :delete]
	before_filter :admin_user, only: [:toggle_admin, :delete]
	
	
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
		@page_id = "user_show"
		@tabs = tabs
		redirect_to root_url
	end
	
	def create
		@user = User.new(params[:user])
		@user.username.downcase
		@user.native_languages = 
			params[:user][:native_languages].gsub(/ /, '').split(',')
		@user.foreign_languages = 
			params[:user][:foreign_languages].gsub(/ /, '').split(',')
		
		if @user.save
			sign_in @user
			flash[:success] = 'Welcome'
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
			flash[:success] = 'You have succcessfully updated your settings.'
			sign_in @user
			redirect_to @user
		else
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
