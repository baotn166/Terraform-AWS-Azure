output "volumes" {
  value = "${split(" ", data.external.all_ebs_volumes.result.volumes)}"
}

