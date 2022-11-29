class AuthController < ApplicationController
	def login
		email = params[:email]
		password = params[:password]
		user = User.find_by(email: email)
		if user.authenticate(password)
			p "Login Successfull"
			redirect_to controller: 'workarea', action: 'upload_form'
		else 
			p "Login Failed"
		end
	end
end