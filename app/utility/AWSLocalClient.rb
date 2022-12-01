require 'aws-sdk-core'
require 'aws-sdk-s3'

class AWSLocalClient
	@@BUCKET_NAME = "aditya-dev"

	def initialize
		aws_region = 'us-east-1'
		endpoint_url = "http://localhost.localstack.cloud:4566"
		credentials = Aws::Credentials.new("AWS_ACCESS_KEY", "AWS_SECRET_KEY")
		# for interacting with s3
		@client = Aws::S3::Client.new(region: aws_region, endpoint: endpoint_url, credentials: credentials)
	end
	def show_buckets
		p @client.list_buckets
	end

	def upload_file_with_metadata? file_name, metadata
		key = File.basename(file_name)
		body = IO.read(file_name)
		response = @client.put_object(bucket: @@BUCKET_NAME, key: key, body: body, metadata: metadata)
		if response.etag
			return true
		else 
			return false
		end
		return false
	end
	
	def upload_result_to_s3? result, file_name, user_email, field_name, operation
		key = "#{file_name}-#{field_name}-#{operation}"
		response = @client.put_object(bucket: @@BUCKET_NAME, key: key, body: result)
		if response.etag
			return true
		else 
			return false
		end
		return false
	end
	
	def get_csv_object file_name
		res = @client.get_object(bucket: @@BUCKET_NAME, key: file_name)
		return res.body.read
	end

	def get_object_metadata file_name
		res = @client.get_object(bucket: @@BUCKET_NAME, key: file_name)
		return res.to_h[:metadata]
	end
end