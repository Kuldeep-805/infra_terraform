# ==============================
# Resource Groups
# ==============================
module "resource_group" {
  source = "../../modules/resourcegroup"

  resource_groups = var.resource_groups
  common_tags     = var.common_tags
}

# ==============================
# Storage Accounts
# ==============================
module "storage_account" {
  source = "../../modules/storageaccount"

  storage_accounts = var.storage_accounts
  common_tags      = var.common_tags

  depends_on = [
    module.resource_group
  ]
}

# ==============================
# Virtual Network + Subnets
# ==============================
module "vnet" {
  source = "../../modules/network/vnet"

  vnets       = var.vnets
  common_tags = var.common_tags

  depends_on = [
    module.resource_group
  ]
}

# ==============================
# Key Vault
# ==============================
module "keyvault" {
  source = "../../modules/keyvault"

  key_vaults  = var.key_vaults
  common_tags = var.common_tags

  depends_on = [
    module.resource_group
  ]
}

# ==============================
# Linux Virtual Machines
# ==============================
module "linux_vm" {
  source = "../../modules/compute/vm_linux"

  vms         = var.linux_vms
  common_tags = var.common_tags

  depends_on = [
    module.resource_group,
    module.vnet
  ]
}

# ==============================
# Windows Virtual Machines
# ==============================
module "windows_vm" {
  source = "../../modules/compute/vm_windows"

  vms         = var.windows_vms
  common_tags = var.common_tags

  depends_on = [
    module.resource_group,
    module.vnet
  ]
}

# ==============================
# Load Balancer
# ==============================
module "loadbalancer" {
  source = "../../modules/loadbalancer"

  loadbalancers = var.loadbalancers
  common_tags   = var.common_tags

  depends_on = [
    module.resource_group,
    module.vnet
  ]
}