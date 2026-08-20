resource "digitalocean_droplet_snapshot" "node-1-before-ubuntu-24-04" {
  droplet_id = digitalocean_droplet.node-1.id
  name       = "node-1-before-ubuntu-24-04"
}

resource "digitalocean_droplet" "node-2" {
  image  = "ubuntu-24-04-x64"
  name   = "node-2"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.mac-air-public.id
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt update"]
  }
}

output "node_2_ipv4_address" {
  value = digitalocean_droplet.node-2.ipv4_address
}
