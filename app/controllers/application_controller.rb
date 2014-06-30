class ApplicationController < ActionController::Base
  protect_from_forgery
	include ApplicationHelper
	
	def handle_unverified_request
		sign_out
		super 
	end
end
