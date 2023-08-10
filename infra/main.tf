# Use bucket to store website

resource "google_storage_bucket" "mywebsite" {
  name = "example-website-by-hikari"
  location = "US"
}

# Make new object public

resource "google_storage_object_access_control" "public_rule" {
  object = google_storage_bucket_object.mysite_index.name
  bucket = google_storage_bucket.mywebsite.name
  role = "READER"
  entity = "allUsers"
}

# Upload the html file to the bucket

resource "google_storage_bucket_object" "mysite_index" {
  name = "index.html"
  source = "../website/index.html"
  bucket = google_storage_bucket.mywebsite.name
}

##############################################################

# Reserve a static external IP address (for google cloud the IP address cannot be dynamic)

resource "google_compute_global_address" "website_ip" {
  name = "website-load-balancer-ip"
}

# Get the managed DNS Zone (which means we already created DNS zone {Network Services/cloud DNS} )

data "google_dns_managed_zone" "dns_zone" {
  name = "my-terraform-gcp"
}

# Add the IP to DNS

resource "google_dns_record_set" "website" {
  name = "website.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl = 300
  managed_zone = data.google_dns_managed_zone.dns_zone.name
  rrdatas = [ google_compute_global_address.website_ip.address ]
}

# Add the bucket as a CDN backend

resource "google_compute_backend_bucket" "website-backend" {
  name = "website-backend"
  bucket_name = google_storage_bucket.mywebsite.name
  description = "Contains files needed for the website"
  enable_cdn = true
}

# GCP URL MAP 
# (a property in the load balancer which allows us to specify when a user enters a specific URL path)

resource "google_compute_url_map" "my-url-map" {
  name = "website-url-map"
  default_service = google_compute_backend_bucket.website-backend.self_link
  host_rule{
    hosts = ["*"] # means anything
    path_matcher = "allpaths"
  }
  path_matcher {
    name = "allpaths"
    default_service = google_compute_backend_bucket.website-backend.self_link
  }
}

# GCP HTTP Proxy

resource "google_compute_target_http_proxy" "website" {
  name = "website-target-proxy"
  url_map = google_compute_url_map.my-url-map.self_link
}

# Create forwarding rule for load balancer

resource "google_compute_global_forwarding_rule" "fwd-rule" {
  name = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.website_ip.address
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_http_proxy.website.self_link
}

