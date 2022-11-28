class AuthController < ApplicationController
	def login
		email = params[:email]
		password = params[:password]
		user = User.find_by(email: email)
		if user.authenticate(password)
			p "correct"
		else 
			p "wrong"
		end
	end
end