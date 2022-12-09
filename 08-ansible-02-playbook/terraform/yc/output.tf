output "clickhouse-01_public_ip_address" {
  value = "${yandex_compute_instance.node-clickhouse.network_interface.0.nat_ip_address}"
}

output "clickhouse-01_local_ip_address" {
  value = "${yandex_compute_instance.node-clickhouse.network_interface.0.ip_address}"
}

output "vector-01_public_ip_address" {
  value = "${yandex_compute_instance.node-vector.network_interface.0.nat_ip_address}"
}

output "vector-01_local_ip_address" {
  value = "${yandex_compute_instance.node-vector.network_interface.0.ip_address}"
}