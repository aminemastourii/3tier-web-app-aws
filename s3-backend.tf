terraform {
  backend "s3" {
    bucket         = "amine-mastouri-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-locking" 
    encrypt        = true
    
  }
  
}