provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

data "external" "all_ebs_volumes" {
  program = ["/bin/bash", "terraform/scripts/get-all-volumes.sh"]
  query = {
    instance_id = "${var.instance_id}"
  }
}

resource "aws_ebs_snapshot" "snapshot_ebs_volume" {
  count     = "${length(split(" ", data.external.all_ebs_volumes.result.volumes))}"
  volume_id = "${element(split(" ", data.external.all_ebs_volumes.result.volumes), count.index)}"
}

#2

#3 Create an S3 bucket using date/time stamp to ensure a unique S3 bucket name.
locals {
  timestamp = "${timestamp()}"
  timestamp_sanitized = "${replace("${local.timestamp}", "/[-| |T|Z|:]/", "")}"

}
resource "aws_s3_bucket" "s3_bucket" {
  #formatdate(spec, timestamp)
  bucket = "${local.timestamp_sanitized}"
  acl    = "private"
}

#4 Copy all content from the volumes of the temporary ec2 instance to the S3 bucket.

#5

#6