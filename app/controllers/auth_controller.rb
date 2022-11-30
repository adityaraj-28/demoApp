class AuthController < ApplicationController
	def login
		email = params[:email]
		password = params[:password]
		user = User.find_by(email: email)
		if user.authenticate(password)
			p "Login Successfull"
			redirect_to controller: 'workarea', action: 'upload_form', owner_email: email
		else 
			p "Login Failed"
		end
	end
end