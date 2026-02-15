output "instance_name" {
  description = "Name of the compute instance"
  value       = google_compute_instance.vm.name
}

output "instance_id" {
  description = "Instance ID"
  value       = google_compute_instance.vm.instance_id
}

output "internal_ip" {
  description = "Internal IP address"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "external_ip" {
  description = "External IP address (if exists)"
  value       = length(google_compute_instance.vm.network_interface[0].access_config) > 0 ? google_compute_instance.vm.network_interface[0].access_config[0].nat_ip : ""
}

output "self_link" {
  description = "Self link of the instance"
  value       = google_compute_instance.vm.self_link
}
