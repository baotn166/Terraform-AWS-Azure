output "volume_ids" {
  value = "${split(" ", data.external.all_ebs_volumes.result.volumes)}"
}

output "snapshot_ids" {
  value = "${aws_ebs_snapshot.snapshot_ebs_volume.*.id}"
}

output "device_ids" {
  value = "${split(" ", data.external.all_device_names.result.devices)}"
}