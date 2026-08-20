resource "digitalocean_record" "A-jmf" {
  domain = "jackmitchellfordyce.com"
  type   = "A"
  name   = "@"
  value  = digitalocean_droplet.node-2.ipv4_address
  ttl    = 1800
}

resource "digitalocean_record" "CNAME-jmf" {
  domain = "jackmitchellfordyce.com"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_domain" "vimtricks" {
  name       = "vimtricks.jackmitchellfordyce.com"
  ip_address = digitalocean_droplet.node-1.ipv4_address
}

resource "digitalocean_domain" "dailyvim" {
  name       = "dailyvim.jackmitchellfordyce.com"
  ip_address = digitalocean_droplet.node-1.ipv4_address
}
