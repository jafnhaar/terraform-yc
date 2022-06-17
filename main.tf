terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.75.0"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone_id
}

resource "yandex_vpc_network" "test-network" {
  name = "test-network"
}

resource "yandex_vpc_subnet" "test-subnet" {
  name           = "test-subnet-sf"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.test-network.id
  v4_cidr_blocks = ["10.200.0.0/16"]
}


module "vm_1" {
  source                = "./yandex_compute"
  vpc_subnet_id         = yandex_vpc_subnet.test-subnet.id
  instance_family_image = "lemp"
}

module "vm_2" {
  source                = "./yandex_compute"
  vpc_subnet_id         = yandex_vpc_subnet.test-subnet.id
  instance_family_image = "lamp"
}


resource "yandex_lb_target_group" "sf-hw" {
  name = "sf-target-group"

  target {
    subnet_id = yandex_vpc_subnet.test-subnet.id
    address   = module.vm_1.internal_ip_address_vm
  }

  target {
    subnet_id = yandex_vpc_subnet.test-subnet.id
    address   = module.vm_2.internal_ip_address_vm
  }
}

resource "yandex_lb_network_load_balancer" "sf-nlb-1" {
  name = "sf-network-load-balancer"

  listener {
    name = "sf-hw-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.sf-hw.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
      }
    }
  }
}