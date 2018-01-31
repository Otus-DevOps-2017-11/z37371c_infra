output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

#output "public_ip" {
#  value = "${google_compute_address.app.address}"
#}

