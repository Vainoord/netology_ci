resource "yandex_compute_instance" "node-clickhouse" {
  name = "clickhouse-01"
  zone = "${var.yandex_zone}"
  hostname = "clickhouse-01.yc.local"
  allow_stopping_for_update = true

  resources {
    cores = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.my-centos-7}"
      name = "root-clickhouse-01"
      type = "network-ssd"
      size = "30"
    }
  }

  network_interface {
    # subnet_id = "${yandex_vpc_subnet.default.id}"
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
  }

  boot_disk {
    initialize_params {
      image_id = "${var.my-debian-11}"
      name = "root-vector-01"
      type = "network-ssd"
      size = "30"
    }
  }

  network_interface {
    #subnet_id = "${yandex_vpc_subnet.default.id}"
    subnet_id = "e9b49r52kacsl96r2cj4"
    nat       = true
  }
}