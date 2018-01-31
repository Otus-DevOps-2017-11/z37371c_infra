variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to private key used by provisioners"
}

variable zone {
  description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable source_ranges {
  description = "Source IP range for accessing Reddit-app"
  default     = "0.0.0.0/0"
}

variable db_url {
  description = "IP address of DB instance"
}

variable prefix {
  description = "Prefix to prepend resource names"
}
