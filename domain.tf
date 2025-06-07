resource "digitalocean_domain" "jmf" {
   name = "jackmitchellfordyce.com"
   ip_address = digitalocean_droplet.node-1.ipv4_address
}

resource "digitalocean_record" "CNAME-jmf" {
  domain = digitalocean_domain.jmf.name
  type = "CNAME"
  name = "www"
  value = "@"
}

resource "digitalocean_domain" "vimtricks" {
   name = "vimtricks.jackmitchellfordyce.com"
   ip_address = digitalocean_droplet.node-1.ipv4_address
}

resource "digitalocean_domain" "dailyvim" {
   name = "dailyvim.jackmitchellfordyce.com"
   ip_address = digitalocean_droplet.node-1.ipv4_address
}
