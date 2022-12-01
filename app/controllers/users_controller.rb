class UsersController < ApplicationController
	def new

	end
	def create
		create_user params[:email], params[:password], params[:source]
	end

	def create_user email, password, source
		if User.find_by(email: email)
			flash[:notice] = "User already exists"
			redirect_to '/workarea/upload_form'
		end
		user = User.new(email: email, password: password, source: source)
		if user.save
			flash[:notice] = "User sucessfully signed up!"
			redirect_to '/workarea/upload_form'
		else
			render 'new'
		end
	end

end
