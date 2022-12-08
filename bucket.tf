resource "aws_s3_bucket" "s3bucket-ammad" {
  bucket = "s3bucket-ammad"
}
/*  server_side_encryption_configuration {*/

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.s3bucket-ammad.id
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
}

resource "aws_s3_bucket_policy" "s3bucket-policy" {
    bucket = aws_s3_bucket.s3bucket-ammad.id

    policy = jsonencode({
        Version = "2012-10-17"
        Id      = "BUCKET-POLICY"
        Statement = [
            {
                Sid       = "EnforceTls"
                Effect    = "Allow"
                Principal = "*"
                Action    = "s3:*"
                Resource = [
                    "${aws_s3_bucket.s3bucket-ammad.arn}/*",
                    "${aws_s3_bucket.s3bucket-ammad.arn}",
                ]
                Condition = {
                    Bool = {
                        "aws:SecureTransport" = "false"
                    }
                }
            },
            {
                Sid       = "EnforceProtoVer"
                Effect    = "Allow"
                Principal = "*"
                Action    = "s3:*"
                Resource = [
                    "${aws_s3_bucket.s3bucket-ammad.arn}/*",
                    "${aws_s3_bucket.s3bucket-ammad.arn}",
                ]
                Condition = {
                    NumericLessThan = {
                        "s3:TlsVersion": 1.2
                    }
                }
            }
        ]
    })
}

resource "aws_s3_bucket" "s3bucket-ammad-logging" {
  bucket = "s3bucket-ammad-logging"
}
resource "aws_s3_bucket_logging" "s3bucket-logging" {
  bucket = aws_s3_bucket.s3bucket-ammad.id

  target_bucket = aws_s3_bucket.s3bucket-ammad.id
  target_prefix = "log/"
}


resource "aws_s3_bucket_versioning" "s3versioning" {
  bucket = aws_s3_bucket.s3bucket-ammad.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_intelligent_tiering_configuration" "intelligent-entire-bucket" {
  bucket = aws_s3_bucket.s3bucket-ammad.bucket
  name   = "Archive-EntireBucket"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 125
  }
}
