provider "aws" {
  region = "ap-southeast-1"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

data "external" "all_ebs_volumes" {
  program = ["/bin/bash", "terraform/scripts/get-all-volumes.sh"]
}

# resource "aws_ebs_snapshot" "ebs_volume" {
#   count     = "${length(data.external.all_ebs_volumes.result.volumes)}"
#   volume_id = "${data.external.all_ebs_volumes.result.volumes.*.id[count.index]}"
# }