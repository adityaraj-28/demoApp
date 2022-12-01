class AuthController < ApplicationController
	def login
		email = params[:email]
		password = params[:password]
		user = User.find_by(email: email)
		if user.authenticate(password)
			p "Login Successfull"
			session[:logged_in] = true
			session[:user]  = email
			redirect_to controller: 'workarea', action: 'upload_form', owner_email: email
		else 
			p "Login Failed"
		end
	end

	def oauth
		args = {
		    client_id: ENV['GOOGLE_CLIENT_ID'],
		    response_type: 'code',
		    scope: 'https://www.googleapis.com/auth/userinfo.email',
		    redirect_uri: 'http://localhost:3000/auth/callback?provider=google',
		    access_type: 'offline'
		 }
		 redirect_to 'https://accounts.google.com/o/oauth2/v2/auth?' + args.to_query, allow_other_host: true
	end

	def callback
		query = {
		    code: params[:code],
		    client_id: ENV['GOOGLE_CLIENT_ID'],
		    client_secret: ENV['GOOGLE_CLIENT_SECRET'],
		    redirect_uri: 'http://localhost:3000/auth/callback?provider=google',
		    grant_type: 'authorization_code'
		}
	  	response = HTTParty.post('https://www.googleapis.com/oauth2/v4/token', query: query)

	  	# Save the access token (step 6)
	  	session[:access_token] = response['access_token']
	  	session[:logged_in] = true
	  	
	  	user_email = get_user_email

	  	session[:user] = user_email
	  	
	  	redirect_to :controller => 'users', :action => 'create' , email: user_email, password: nil, source: 'google'
	end

	def logout
		session.delete(:access_token)
		session[:logged_in] = false
		session.delete(:user)
		redirect_to '/'
	end

	private 
	def get_user_email
		headers = {
		  'Content-Type': 'application/json',
		  'Authorization': "Bearer #{session[:access_token]}"
		}
		res = HTTParty.get('https://www.googleapis.com/oauth2/v3/userinfo', headers: headers)
		return res["email"]
	end
end