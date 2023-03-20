terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  token = "dop_v1_84bb7b9f3acb476edf5b96ae8c841ea2b0fa374f2c7ad87655b4469153ae3068"
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
