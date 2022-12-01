require "gnuplot"

class WorkareaController < ApplicationController
	@@client = AWSLocalClient.new
	def index
	end

	def upload_form
		@user_email = params[:owner_email]
		p "In upload_form"
	end

	def upload_csv
		user_email = params[:user_email]
		metadata = {
			user_email: user_email
		}
		if @@client.upload_file_with_metadata? params[:file_path], metadata
			message = "Upload Successful"
		else 
			message = "Upload Failed"
		end
		redirect_to controller: 'notification', action: 'notify', message: message, user_email: user_email
	end

	def get_csv_template
		user_email = params[:user_email]
		file_name = File.basename(params[:file_name])
		csv_string = @@client.get_csv_object file_name
		list = get_template_list csv_string
		message = "CSV Template: " + list.join(", ")
		redirect_to controller: 'notification', action: 'notify', message: message, user_email: user_email
	end

	def get_stats
		file_name = params[:file_name]
		user_email = params[:user_email]
		field_name = params[:field_name]
		operation = params[:operation]
		csv_string = @@client.get_csv_object file_name
		metadata = @@client.get_object_metadata file_name

		object_owners_email = metadata["user_email"]

		if object_owners_email != user_email
			message = "The file doesn't belongs to the user"
			redirect_to controller: 'notification', action: 'notify', message: message
		end
		#edge case: same file name may belong to different users

		if operation == "max"
			res = get_max_value_for_field csv_string, field_name
		elsif operation == "median" 
			res = get_median_for_field csv_string, field_name
		end
		message = "#{operation} of #{field_name} for #{file_name} is: #{res}"
		
		NewStatsMailer.send_email(to_user: user_email, message: message).deliver_later

		if @@client.upload_result_to_s3? message, file_name, user_email, field_name, operation
			p "Result uploaded to csv"
		else
			p "Result upload to s3 failed"
		end 

		redirect_to controller: 'notification', action: 'notify', message: message
	end

	private
	def get_max_value_for_field csv_string, field_name
		#validate all fields are numbers
		values = get_all_field_values csv_string, field_name
		return values.max
	end

	private
	def get_median_for_field csv_string, field_name
		#validate all fields are numbers 
		values = get_all_field_values csv_string, field_name
		res = nil if values.empty?
		sorted = values.sort
		len = sorted.length
		res = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
		return res
	end

	private
	def get_template_list csv_string
		return csv_string[0, csv_string.index("\r")].split(",")
	end

	private 
	def get_all_field_values csv_string, field_name
		rows = csv_string.split("\n")
		headers = get_template_list csv_string
		pos = headers.index(field_name)
		res = []
		rows_without_header = rows[1, rows.length - 1]
		for line in rows_without_header
			line = line[0, line.length - 1]
			values = line.split(",")
			res.append(values[pos])
		end
		return res
	end
	
end
