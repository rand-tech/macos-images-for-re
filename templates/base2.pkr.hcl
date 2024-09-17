packer {
  required_plugins {
    tart = {
      version = ">= 1.12.0"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

locals {
  image_folder = "/Users/admin/image-generation"
}

variable "macos_version" {
  type = string
}

variable "vm_username" {
  type      = string
  sensitive = false
  default   = "admin"
}

variable "vm_password" {
  type      = string
  sensitive = true
  default   = "admin"
}

source "tart-cli" "tart" {
  vm_base_name = "${var.macos_version}-base"
  vm_name      = "${var.macos_version}-supplmental2"
  cpu_count    = 4
  memory_gb    = 8
  disk_size_gb = 50
  ssh_password = "${var.vm_password}"
  ssh_username = "${var.vm_username}"
  ssh_timeout  = "120s"
}

build {
  sources = ["source.tart-cli.tart"]

  provisioner "shell" {
    inline = ["mkdir -p ${local.image_folder}"]
  }
  provisioner "file" {
    destination = "${local.image_folder}/"
    sources     = [
      "${path.root}/../scripts/helpers"
    ]
  }
  provisioner "file" {
    destination = "${local.image_folder}/toolset.json"
    source      = "${path.root}/../toolsets/toolset-14.json"
  }
  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline          = [
      "mkdir -p ~/utils",
      "mv ${local.image_folder}/helpers/utils.sh ~/utils",
    ]
  }

  provisioner "shell" {
    execute_command  = "chmod +x {{ .Path }}; source $HOME/.zprofile; {{ .Vars }} {{ .Path }}"
    scripts          = [
      "${path.root}/../scripts/build/configure-tccdb-macos.sh",
      "${path.root}/../scripts/build/configure-auto-updates.sh",
      "${path.root}/../scripts/build/configure-machine.sh"
    ]
  }

  provisioner "shell" {
    execute_command   = "source $HOME/.zprofile; sudo {{ .Vars }} {{ .Path }}"
    expect_disconnect = true
    inline            = ["echo 'Reboot VM'", "shutdown -r now"]
  }

  provisioner "shell" {
    environment_vars = ["USER_PASSWORD=${var.vm_password}", "IMAGE_FOLDER=${local.image_folder}"]
    execute_command  = "chmod +x {{ .Path }}; source $HOME/.zprofile; {{ .Vars }} {{ .Path }}"
    pause_before     = "30s"
    scripts          = [
      "${path.root}/../scripts/build/install-binaryanalysis.sh",
    ]
  }

  provisioner "shell" {
    environment_vars = ["USER_PASSWORD=${var.vm_password}", "IMAGE_FOLDER=${local.image_folder}"]
    execute_command  = "chmod +x {{ .Path }}; source $HOME/.zprofile; {{ .Vars }} {{ .Path }}"
    pause_before     = "30s"
    scripts          = [
      // "${path.root}/../scripts/build/configure-windows.sh",
      "${path.root}/../scripts/build/install-python.sh",
      "${path.root}/../scripts/build/install-openssl.sh",
      "${path.root}/../scripts/build/install-git.sh",
      "${path.root}/../scripts/build/install-common-utils.sh",
      "${path.root}/../scripts/build/install-llvm.sh",
      // "${path.root}/../scripts/build/install-openjdk.sh",
    ]
  }

}
