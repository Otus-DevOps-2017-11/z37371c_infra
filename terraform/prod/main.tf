provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source           = "../modules/app"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone             = "${var.zone}"
  app_disk_image   = "${var.app_disk_image}"
  db_url           = "${module.db.db_internal_ip}"
  prefix           = "${var.prefix}"
}

module "db" {
  source           = "../modules/db"
  private_key_path = "${var.private_key_path}"
  public_key_path  = "${var.public_key_path}"
  zone             = "${var.zone}"
  db_disk_image    = "${var.db_disk_image}"
  prefix           = "${var.prefix}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
  prefix        = "${var.prefix}"
}

terraform {
  backend "gcs" {
    bucket = "terraform-state-remote-backend"
    prefix = "prod"
  }
}
