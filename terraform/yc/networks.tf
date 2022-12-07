# YC | Init network
#resource "yandex_vpc_network" "default" {
#  name = "netology_net"
#}

# YC | Init subnet
#resource "yandex_vpc_subnet" "default" {
#  name = "netology_subnet"
#  zone = var.yandex_zone
#  network_id = "${yandex_vpc_network.default.id}"
#  v4_cidr_blocks = ["192.168.150.0/24"]
#}