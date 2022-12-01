class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		byebug
		if User.find(user[:id])
			flash[:notice] = "User already exists"
		if @user.save
			flash[:notice] = "User sucessfully signed up!"
			redirect_to '/workarea/index'
		else
			render 'new'
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :password)
	end
end
