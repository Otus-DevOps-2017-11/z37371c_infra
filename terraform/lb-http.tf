resource "google_compute_address" "app" {
  name = "redit-app-address"
}

resource "google_compute_target_pool" "app" {
  name          = "reddit-app-target-pool"
  instances     = ["${google_compute_instance.app.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.http.name}"]
}

resource "google_compute_forwarding_rule" "http" {
  name       = "www-http-forwarding-rule"
  target     = "${google_compute_target_pool.app.self_link}"
  ip_address = "${google_compute_address.app.address}"
  port_range = "9292"
}

resource "google_compute_http_health_check" "http" {
  name                = "www-http-basic-check"
  request_path        = "/"
  check_interval_sec  = 1
  healthy_threshold   = 1
  unhealthy_threshold = 10
  port                = 9292
  timeout_sec         = 1
}
