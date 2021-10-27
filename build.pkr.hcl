source "azure-arm" "agent" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  managed_image_resource_group_name = "cicd"
  managed_image_name     = "cicd_default_ubuntu_1804_${var.image_tag}"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "18.04-LTS"

  location  = "East US"
  vm_size   = "Standard_DS2_v2"
}

build {
  sources = ["sources.azure-arm.agent"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo {{ .Path }}"
    script = "./provisioner.sh"
  }
}