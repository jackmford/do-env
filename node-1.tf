resource "digitalocean_droplet" "node-1" {
  image  = "ubuntu-20-04-x64"
  name   = "node-1"
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
    inline = [
      "export PATH=$PATH:/usr/bin",
      # update
      "sudo apt update",
    ]
  }
}
