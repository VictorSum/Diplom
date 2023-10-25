terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {  
  token     = #youtoken
  cloud_id  = #youcloudid
  folder_id = #youforderid
}

########## WEB #########

resource "yandex_compute_instance" "web-1" {
  name        = "web-1"
  hostname    = "web-1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-web-1.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "192.168.1.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

resource "yandex_compute_instance" "web-2" {
  name        = "web-2"
  hostname    = "web-2"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id  
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-web-2.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "192.168.2.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

# Snapshots
resource "yandex_compute_snapshot_schedule" "default" {
  name = "vms-snapshots"

  schedule_policy {
    expression = "0 0 * * *"
  }

  snapshot_count = 1

  snapshot_spec {
    description = "snapshot-description"
    labels = {
      snapshot-label = "my-snapshot-label-value"
    }
  }

  labels = {
    my-label = "my-label-value"
  }

  disk_ids = [
    yandex_compute_instance.web-1.boot_disk[0].device_name,
    yandex_compute_instance.web-2.boot_disk[0].device_name,
    yandex_compute_instance.bastion.boot_disk[0].device_name,
    yandex_compute_instance.grafana.boot_disk[0].device_name,
    yandex_compute_instance.prometheus.boot_disk[0].device_name,
    yandex_compute_instance.kibana.boot_disk[0].device_name,

  ]

}

####### Bastion #######

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd82v0f4ufbnvm3b9s08" # NAT-èíñòàíñ
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-bastion.id]
    ip_address         = "192.168.4.4"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

###### Prometheus #######

resource "yandex_compute_instance" "prometheus" {
  name        = "prometheus"
  hostname    = "prometheus"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id 
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-services.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "192.168.3.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

##### GRAFANA #####

resource "yandex_compute_instance" "grafana" {
  name        = "grafana"
  hostname    = "grafana"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id 
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-grafana.id]
    ip_address         = "192.168.4.5"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

#####  Elastiс ######

resource "yandex_compute_instance" "elastic" {
  name        = "elastic"
  hostname    = "elastic"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id 
      size     = 6
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-services.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "192.168.3.4"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

####### Kibana ########

resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id 
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-kibana.id]
    ip_address         = "192.168.4.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

