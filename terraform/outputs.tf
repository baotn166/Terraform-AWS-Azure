# output "ebs_volume_id" {
#   value = ["${data.aws_instance.ec2.ebs_block_device}"]
# }
# output "root_dev" {
#   value = ["${data.aws_instance.ec2.root_block_device}"]
# }
output "all_volumes" {
  value = ["${data.external.all_ebs_volumes.result.volumes}"]
}
