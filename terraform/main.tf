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
