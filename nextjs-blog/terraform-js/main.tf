provider "aws" {
    region = "us-east-1"
}

# S3 bucket

resource "aws_s3_bucket" "nextjs_bucket"{
    bucket = "nextjs-portfolio-bucket-zaid"
}

# Ownership Control [purpose is to find owner of the bucket]

resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls" {
    bucket = aws_s3_bucket.nextjs_bucket.id
    rule {
        object_ownership = "BucketOwnerPrefferred"
    }
}

# Block public Access [ to prevent all onauthorise purson acccess ]
resource "aws_s3_bucket_public_access_block" "nextjs_bucket_public_access_block" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

# Bucket ACL  [ to define granuller access permission ]
resource "aws_s3_bucket_acl" "nextjs_bucket_acl"{
    depends_on = [
        aws_s3_bucket_ownership_controls.nextjs,
        aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
    ]

    bucket = aws_s3_bucket.nextjs_bucket.id
    acl = "public-read"
}

# bucket policy [is to define detail access permission]

resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    policy = jsondecode (({
        version = "2012-10-17"
        Statement = [
            {
                Sid = "PublicReadGetObject"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
            }
        ]
    }))
}