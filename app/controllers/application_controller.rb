class ApplicationController < ActionController::Base
	def index
		if session[:user]
			@message = "welcome #{session[:user]}"
		else
			@message = "No user currently logged in"
		end
	end
end
