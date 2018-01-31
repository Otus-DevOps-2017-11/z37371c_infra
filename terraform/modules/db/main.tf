resource "google_compute_instance" "db" {
  name         = "${var.prefix}-reddit-db"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["${var.prefix}-reddit-db"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i \"s/127.0.0.1/$(hostname -I)/g\" /etc/mongod.conf",
      "sudo service mongod restart",
    ]
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "${var.prefix}-allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # правило применимо к инстансам с тегом ...
  target_tags = ["${var.prefix}-reddit-db"]

  # порт будет доступен только для инстансов с тегом ...
  source_tags = ["${var.prefix}-reddit-app"]
}
