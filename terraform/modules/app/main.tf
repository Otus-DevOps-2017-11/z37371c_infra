resource "google_compute_instance" "app" {
  name         = "${var.prefix}-reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["${var.prefix}-reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    private_key = "${file(var.private_key_path)}"
  }
/*
  provisioner "file" {
    content     = "${data.template_file.puma_unit.rendered}"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
*/
}

resource "google_compute_address" "app_ip" {
  name = "${var.prefix}-reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "${var.prefix}-allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-reddit-app"]
}
/*
data "template_file" "puma_unit" {
  template = "${file("${path.module}/files/puma.service.tpl")}"

  vars {
    db_url = "${var.db_url}"
  }

}
*/