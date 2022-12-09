# YC token
variable "yandex_token" {
  default = ""
}

# YC | service account auth_key
variable "yandex_service_account_file" {
  default = "./meta/authorized_key.json"
}

# YC | cloud ID
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = ""
}

# YC | cloud folder ID
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = ""
}

# YC | Base Centos 7 image
variable "centos-7" {
  default = "fd88d14a6790do254kj7"
}

# YC | Base Ubuntu 22.04 image
variable "ubuntu-2204" {
  default = "fd8egv6phshj1f64q94n"
}

# YC | Base Debian 11 image
variable "debian-11" {
  default = "fd8mejp64t7hgh4rfs93"
}

# YC | Custom Centos 7 image
variable "my-centos-7" {
  default = ""
}

# YC | Custom Debian 11 image
variable "my-debian-11" {
  default = ""
}
# YC | cloud zone
variable "yandex_zone" {
  default = "ru-central1-a"
}

# YC | subnet id
variable "subnet-id" {
  default = ""
}