output "frontend_url" {

  value = "http://${var.hostname}.${var.hosted_zone_name}"
}

