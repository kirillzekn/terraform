resource "aws_s3_bucket" "s3-eu" {
    bucket="zekn-s3-eu"
    acl = "private"
}

resource "aws_s3_bucket" "s3-us" {
    bucket="zekn-s3-us"
    acl = "private"
    provider = aws.us
}