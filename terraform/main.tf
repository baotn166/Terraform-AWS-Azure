provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

data "external" "all_ebs_volumes" {
  program = ["/bin/sh", "terraform/scripts/get-all-volumes.sh"]
  query = {
    instance_id = "${var.instance_id}"
    aws_access_key_id = "${var.aws_access_key_id}"
    aws_secret_access_key = "${var.aws_secret_access_key}"
    aws_region = "${var.region}"
  }
}

resource "aws_ebs_snapshot" "snapshot_ebs_volume" {
  count     = "${length(split(" ", data.external.all_ebs_volumes.result.volumes))}"
  volume_id = "${element(split(" ", data.external.all_ebs_volumes.result.volumes), count.index)}"
}

#2

data "aws_instance" "main_ec2" {
  instance_id = "${var.instance_id}"
}

resource "aws_ebs_volume" "restored_ebs_volume" {
  count             = "${length(split(" ", data.external.all_ebs_volumes.result.volumes))}"
  snapshot_id       = "${element(aws_ebs_snapshot.snapshot_ebs_volume.*.id, count.index)}"
  availability_zone = "${data.aws_instance.main_ec2.availability_zone}"
  depends_on        = ["aws_ebs_snapshot.snapshot_ebs_volume"]
}

resource "aws_instance" "temp_ec2" {
  ami             = "${data.aws_instance.main_ec2.ami}"
  instance_type   = "${data.aws_instance.main_ec2.instance_type}"
  key_name        = "${data.aws_instance.main_ec2.key_name}"
  security_groups = "${data.aws_instance.main_ec2.security_groups}"
}

data "external" "all_device_names" {
  program = ["/bin/sh", "terraform/scripts/get-all-device-names.sh"]
  query = {
    instance_id = "${var.instance_id}"
    aws_access_key_id = "${var.aws_access_key_id}"
    aws_secret_access_key = "${var.aws_secret_access_key}"
    aws_region = "${var.region}"
  }
}


resource "aws_volume_attachment" "temp_volume_attachment" {
  count       = "${length(split(" ", data.external.all_ebs_volumes.result.volumes))}"
  device_name = "${element(split(" ", data.external.all_device_names.result.devices), count.index)}"
  volume_id   = "${element(aws_ebs_volume.restored_ebs_volume.*.id, count.index)}"
  instance_id = "${aws_instance.temp_ec2.id}"
  depends_on  = ["aws_ebs_volume.restored_ebs_volume","aws_instance.temp_ec2"]
}


#3 Create an S3 bucket using date/time stamp to ensure a unique S3 bucket name.
locals {
  timestamp = "${timestamp()}"
  timestamp_sanitized = "${replace("${local.timestamp}", "/[-| |T|Z|:]/", "")}"

}
resource "aws_s3_bucket" "s3_bucket" {
  #formatdate(spec, timestamp)
  bucket = "${local.timestamp_sanitized}"
  acl    = "private"
  depends_on = ["aws_volume_attachment.temp_volume_attachment"]
}

#4 Copy all content from the volumes of the temporary ec2 instance to the S3 bucket.

resource "null_resource" "mount_volume" {
  provisioner "local-exec" {
    command = "bash terraform/scripts/login-ec2-instance.sh ${aws_instance.temp_ec2.id} ${var.region} ${aws_s3_bucket.s3_bucket.bucket}"
  }
  triggers = {
    build_number = "${timestamp()}"
  }
  depends_on = ["aws_s3_bucket.s3_bucket"]
}
#5

#6