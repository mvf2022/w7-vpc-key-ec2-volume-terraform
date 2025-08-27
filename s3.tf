resource "aws_s3_bucket" "s3" {
  bucket = "week7-dsg-bucket-your_name"

tags = {
  name = "my bucket"
  environment = "Dev"
}

}