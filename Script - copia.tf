terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  token = "dop_v1_68902e891b9af64f5ba53d7f05096cc0ed2324f5ec203248e7c4f18cc739b6ee"
}

data "digitalocean_ssh_key" "josue" {
  name= "jb"
  #public_key = file("~/.ssh/id_rsa.pub")
}


resource "digitalocean_droplet" "josue" {
  image  = "ubuntu-20-04-x64"
  name   = "mjb2"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.josue.id
  ]
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
    host     = self.ipv4_address
  }


provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y git",
      "apt-get update",
      "snap install docker          # version 20.10.17",
      "sudo apt-get update",
      "sudo apt-get install -y default-jdk",
      "wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get update",
      "sudo apt-get install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins",
      "sudo ufw allow 8080/tcp"
    ]
  
  }

}
