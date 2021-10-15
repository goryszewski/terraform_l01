


resource "libvirt_volume" "os_image" {
  name = "${var.hostname}-os_image"
  pool = "pool-HDD"
  source = "/srv/vm/hdd/ubuntu-21.10-server-cloudimg-amd64.img"
  format = "qcow2"
}


resource "libvirt_cloudinit_disk" "commoninit" {
          name = "${var.hostname}-commoninit.iso"
          pool = "pool-HDD"
          user_data = data.template_file.user_data.rendered
          network_config = data.template_file.network_config.rendered
}


data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.hostname
    fqdn = "${var.hostname}.${var.domain}"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config_dhcp.cfg")
    vars = {
    domain = var.domain
    prefixIP = var.prefix
    octetIP = var.ip
  }
}


resource "libvirt_domain" "domain-ubuntu02" {
  name = var.hostname
  memory = var.memoryMB
  vcpu = var.cpu

  disk {
       volume_id = libvirt_volume.os_image.id
  }
  network_interface {
       network_name = "internal"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  # IMPORTANT
  # Ubuntu can hang is a isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = "true"
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

terraform {
  required_version = ">= 1.0.1"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.6.10"
    }
  }
}
