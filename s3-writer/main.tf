provider "aws" {
  region = "eu-west-1"
  access_key = "${var.AWS_ACCESS_KEY == "none" ? "" : var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_ACCESS == "none" ? "" : var.AWS_SECRET_ACCESS}"
}

resource "aws_s3_bucket_object" "object" {
  bucket  = "${var.BUCKET_NAME}"
  key     = "${var.SANDBOX_ID}"
  content = "USER_CONTENT:${var.USER_CONTENT}\nSERVER_NAME:${var.SERVER_NAME}\nSERVER_VERSION:${var.SERVER_VERSION}\nOUTPUT_PUBLISHER_STR:${var.OUTPUT_PUBLISHER_STR}\nSANDBOX_DETAILS:${var.SANDBOX_DETAILS}\nPUBLIC_ADDRESS:${var.PUBLIC_ADDRESS}"
}

data "external" "presign" {
  program = ["bash", "presign.sh", "${var.BUCKET_NAME}", "${var.SANDBOX_ID}", "${var.AWS_ACCESS_KEY}", "${var.AWS_SECRET_ACCESS}"]
}

output "s3_file_url" {
  value = "${data.external.presign.result.url}"
}
