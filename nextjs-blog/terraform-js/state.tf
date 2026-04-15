terraform {
    backend "s3" {
        bucket = "my-terraform-state-zaid3"
        key = "global/s3/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-locks"
        encrypt = true

    }
}