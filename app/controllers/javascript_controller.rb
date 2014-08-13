class JavascriptController < ApplicationController
	
	def coffee
		respond_to do |format|
			format.js
		end
	end
	
	def messages
		respond_to do |format|
			format.js
		end
	end
	
end
