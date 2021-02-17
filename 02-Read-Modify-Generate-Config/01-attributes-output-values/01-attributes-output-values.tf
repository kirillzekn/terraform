provider "aws" {
  region = "eu-central-1"

}

resource "aws_s3_bucket" "my_s3_bucket" {
    bucket="zekn-my-s3-bucket"
    acl="private"
}

output "aws-s3-output1" {value=aws_s3_bucket.my_s3_bucket.bucket_domain_name}
output "aws-s3-output2" {value=aws_s3_bucket.my_s3_bucket.arn}
output "aws-s3-output3" {value=aws_s3_bucket.my_s3_bucket.id}
