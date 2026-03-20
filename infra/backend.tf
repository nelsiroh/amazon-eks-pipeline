terraform {
  backend "s3" {
    bucket         = "aethernubis-tfstate-bucket-us-east-2"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "aethernubis-tf-lock-table-us-east-2"
    kms_key_id     = "alias/aethernubis-tfstate-key-us-east-2"
  }
}
