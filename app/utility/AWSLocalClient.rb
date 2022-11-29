require 'aws-sdk-core'
require 'aws-sdk-s3'

class S3Client
  def initialize
    aws_region = 'us-east-1'
    endpoint_url = "http://localhost.localstack.cloud:4566"
    credentials = Aws::Credentials.new("AWS_ACCESS_KEY", "AWS_SECRET_KEY")
    # for interacting with s3
    @@client = Aws::S3::Client.new(region: aws_region, endpoint: endpoint_url, credentials: credentials)
  end
end
