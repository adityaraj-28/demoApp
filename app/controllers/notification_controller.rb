class NotificationController < ApplicationController
	def notify
		@message = params[:message]
	end
end