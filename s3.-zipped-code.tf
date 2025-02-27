resource "aws_s3_bucket" "app-bucket" {
  bucket="zipped-guessthenumber"
}
resource "aws_s3_object" "app-content" {
    bucket = aws_s3_bucket.app-bucket.bucket
  source = "../../GuessTheNumber.zip"
  key = "GuessTheNumber.zip"
}