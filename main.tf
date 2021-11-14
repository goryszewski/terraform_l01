module "pl1-node201-api"{
  source ="./libvirt"
  hostname ="pl1-node201"
  domain = "api.cloud.local"
  ip="201"
}

module "pl1-rsyslog01-core"{
  source ="./libvirt"
  domain = "core.cloud.local"
  hostname ="pl1-rsyslog01"
  ip="101"
}

module "pl1-jenkins01-core"{
  source ="./libvirt"
  domain = "core.cloud.local"
  hostname ="pl1-jenkins01"
  ip="102"
}

module "pl1-jenkins01-node01-core"{
  source ="./libvirt"
  domain = "core.cloud.local"
  hostname ="pl1-jenkins01-node01"
  ip="103"
}