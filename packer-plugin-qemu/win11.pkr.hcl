packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

source "qemu" "win11" {
  # ISO Details
  iso_url          = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/22631.2428.231001-0608.23H2_NI_RELEASE_SVC_REFRESH_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
  iso_checksum     = "sha256:c8dbc96b61d04c8b01faf6ce0794fdf33965c7b350eaa3eb1e6697019902945c"

  # Boot Configuration & Setup Files
  floppy_files = [
    "./unattends/Autounattend.xml",
    "./unattends/Firstboot-Autounattend.xml",
    "./win11/scripts/bootstrap.bat",
    "./win11/scripts/set-network.ps1",
    "./win11/scripts/install-misc.bat",
    "./win11/scripts/enable-winrm.ps1",
    "./win11/drivers/"
  ]
  boot_wait    = "5s"
  boot_command = ["<spacebar><wait>"]

  # Communicator Details (WinRM)
  communicator     = "winrm"
  winrm_username   = "vagrant"
  winrm_password   = "vagrant"
  winrm_insecure   = "true"
  winrm_use_ssl    = "true"
  winrm_timeout    = "30m"

  # VM Resources (CPU/Memory)
  cpus             = "4"
  memory           = "4096"

  # Disk Configuration
  disk_cache        = "none"
  disk_compression  = "true"
  disk_discard      = "unmap"
  disk_interface    = "virtio"
  disk_size         = "61440"
  format            = "qcow2"

  # Network Configuration
  net_device = "virtio-net"

  # QEMU Configuration
  accelerator      = "kvm"
  headless         = "false"
  vga              = "qxl"
  efi_boot         = "true"

  # Artifacts Output
  output_directory = "output-win11"

  # Shutdown Command
  shutdown_command = "%WINDIR%/system32/sysprep/sysprep.exe /generalize /oobe /shutdown /unattend:C:/Windows/Temp/Autounattend.xml"
}

build {
  sources = ["source.qemu.win11"]

  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c C:/Windows/Temp/script.bat"
    remote_path     = "c:/Windows/Temp/script.bat"
    scripts         = ["./win11/scripts/install-misc.bat"]
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
  }
}
