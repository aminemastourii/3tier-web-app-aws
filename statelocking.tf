resource "aws_s3_bucket" "tfstate" {
  bucket     = "amine-mastouri-tf-state"
  depends_on = [aws_dynamodb_table.state-locking]
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [aws_s3_bucket.tfstate]
}

resource "aws_s3_object" "tfstate-upload" {
  bucket     = aws_s3_bucket.tfstate.bucket
  key        = "terraform.tfstate"
  source     = "terraform.tfstate"
  depends_on = [aws_s3_bucket_versioning.versioning]
}

resource "aws_dynamodb_table" "state-locking" {
  hash_key = "LockID"
  name     = "tfstate-locking"
  billing_mode = "PAY_PER_REQUEST"


  attribute {
    name = "LockID"
    type = "S"
  }




}
