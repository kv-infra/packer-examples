packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

source "qemu" "fedora40" {
  # ISO Details
  iso_url      = "https://fedora.cu.be/linux/releases/40/Server/x86_64/iso/Fedora-Server-netinst-x86_64-40-1.14.iso"
  iso_checksum = "file:https://fedora.cu.be/linux/releases/40/Server/x86_64/iso/Fedora-Server-40-1.14-x86_64-CHECKSUM"

  # Boot Configuration
  boot_command = [
    "<up>e",
    "<down><down><end>",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kickstarts/fedora40-kickstart.cfg",
    "<leftCtrlOn>x<leftCtrlOff>"
  ]
  boot_wait    = "10s"

  # Communicator Details (SSH)
  communicator     = "ssh"
  ssh_username     = "root"
  ssh_password     = "root"
  ssh_wait_timeout = "30m"

  # VM Resources (CPU/Memory)
  cpus             = "2"
  memory           = "2048"

  # Disk Configuration
  disk_cache        = "none"
  disk_compression  = "true"
  disk_discard      = "unmap"
  disk_interface    = "virtio"
  disk_size         = "40000"
  format            = "qcow2"

  # Network Configuration
  net_device = "virtio-net"

  # QEMU Configuration
  accelerator = "kvm"
  headless    = "false"

  # HTTP Server Configuration
  http_directory = "."

  # Artifacts Output
  output_directory = "output-fedora40"

  # Shutdown Command
  shutdown_command = "sudo /usr/sbin/shutdown -h now"
}

build {
    sources = ["source.qemu.fedora40"]

    provisioner "shell" {
        inline = [
            "sudo dnf -y upgrade",
            "echo 'System updated and upgraded.'"
        ]
    }
}
