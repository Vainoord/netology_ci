#resource "yandex_compute_instance" "node-lighthouse" {
#  name = "lighthouse-01"
#  zone = "${var.yandex_zone}"
#  hostname = "lighthouse-01.yc.local"
#  allow_stopping_for_update = true

#  resources {
#    cores = 2
#    memory = 2
#    core_fraction = 20
#  }

#  boot_disk {
#    initialize_params {
#      image_id = "${var.my-centos-7}"
#      name = "root-lighthouse-01"
#      type = "network-ssd"
#      size = "20"
#    }
#  }

#  network_interface {
#    subnet_id = "${var.subnet-id}"
#    nat = true
#  }
#}

resource "yandex_compute_instance" "node-clickhouse" {
  name = "clickhouse-01"
  zone = "${var.yandex_zone}"
  hostname = "clickhouse-01.yc.local"
  allow_stopping_for_update = true

  resources {
    cores = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "${var.my-centos-7}"
      name = "root-clickhouse-01"
      type = "network-ssd"
      size = "20"
    }
  }

  network_interface {
    subnet_id = "${var.subnet-id}"
    nat = true
  }
}

resource "yandex_compute_instance" "node-vector" {
  name = "vector-01"
  zone = "${var.yandex_zone}"
  hostname = "vector-01.yc.local"
  allow_stopping_for_update = true

  resources {
    cores = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "${var.my-debian-11}"
      name = "root-vector-01"
      type = "network-ssd"
      size = "20"
    }
  }

  network_interface {
    subnet_id = "${var.subnet-id}"
    nat       = true
  }
}