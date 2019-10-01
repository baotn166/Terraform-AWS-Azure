provider "aws" {
  region = "ap-southeast-1"
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
  security_groups = ["${data.aws_instance.main_ec2.security_groups}"]
}

data "external" "all_device_names" {
  program = ["/bin/bash", "terraform/scripts/get-all-device-names.sh"]
  query = {
    instance_id = "${var.instance_id}"
  }
}


resource "aws_volume_attachment" "temp_volume_attachment" {
  count       = "${length(split(" ", data.external.all_ebs_volumes.result.volumes))}"
  device_name = "${element(split(" ", data.external.all_device_names.result.devices), count.index)}"
  volume_id   = "${element(aws_ebs_volume.restored_ebs_volume.*.id, count.index)}"
  instance_id = "${aws_instance.temp_ec2.id}"
  depends_on  = ["aws_ebs_volume.restored_ebs_volume","aws_instance.temp_ec2"]
}


#3

#4

#5

#6