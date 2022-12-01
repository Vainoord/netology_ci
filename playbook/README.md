# 8.2 Playbook description

This playbook sets up the Clickhouse DBMS and the Vector to transfer data on two docker containers. Each container will keep one application.

## GROUP VARS

### Clickhouse

_clickhouse_version_ - define a version of the Clickhouse package for installation.\
_clickhouse_packages_ - a list of the Clickhouse packages for downloading.

### Vector

_vector_version_ - a version of the Vector.\
_vector_package_ - a name of the Vector.\
_os_architecture_ - an OS instruction set.

## Playbook tasks

### Localhost

__Create docker network__ (Tag `create_docker_network`) - create a docker network.\
__Create a Centos image__ (Tag `run_clickhouse_container`) - create an image based on Centos:7 with packages `sudo` and `python3`.\
__Create a Debian image__ (Tag `run_vector_container`) - create an image based on Debian:11.5 with `python3` package.\
__Run Centos container__ (Tag `run_clickhouse_container`) - run docker container with Centos.\
__Run Debian container__ (Tag `run_vector_container`) - run docker container with Debian.

### Clickhouse

__Get clickhouse distrib__ (Tag `start_clickhouse`) - download packages clickhouse-server, clickhouse-client, clickhouse-common.\
__Install clickhouse packages__ (Tag `get_clickhouse`) - deploy the Clickhouse.\
__Start clickhouse server__ (Tag `install_clickhouse`) - launch clickhouse-server process.\
__Generate users config__ (Tag `configure_clickhouse`) - generate users.xml file with Clickhouse users.\
__Create database__ (Tag `configure_clickhouse`) - create test database as an example.

### Vector

__Mkdir for vector__ (Tag `mkdir_vector`) - create directory for the Vector package.\
__Get vector distrib__ (Tag `get_vector`) - download specified Vector package.\
__Install vector package__ (Tag `install_vector`) - install Vector application.

---


# 8.2 Описание Playbook 

Этот playbook устанавливает в два докер контейнера СУБД clickhouse и vector для передачи данных.

## Переменные

### Clickhouse

_clickhouse_version_ - версия устанавливаемого пакета clickhouse.\
_clickhouse_packages_ - список пакетов clickhouse для скачивания.

### Vector

_vector_version_ - версия устанавливаемого пакета vector.\
_vector_package_ - имя пакета vector.\
_os_architecture_ - тип архитектуры OS пакета.

## Playbook tasks

### Localhost

__Create docker network__ (Тег `create_docker_network`) - создание docker сети.\
__Create a Centos image__ (Тег `run_clickhouse_container`) - создание образа из Centos:7 c установленными пакетами `sudo` и `python3`.\
__Create a Debian image__ (Тег `run_vector_container`) - создание образа из Centos:7 c установленным пакетом `python3`.\
__Run Centos container__ (Тег `run_clickhouse_container`) - запуск docker контейнета с Centos.\
__Run Debian container__ (Тег `run_vector_container`) - запуск docker контейнера с Debian.

### Clickhouse

__Get clickhouse distrib__ (Тег `start_clickhouse`) - скачивание пакетов clickhouse-server, clickhouse-client, clickhouse-common.\
__Install clickhouse packages__ (Тег `get_clickhouse`) - развертывание Clickhouse.\
__Start clickhouse server__ (Тег `install_clickhouse`) - запуск службы clickhouse-server.\
__Generate users config__ (Tag `configure_clickhouse`) - генерация файла users.xml с пользователями Clickhouse.\
__Create database__ (Тег `configure_clickhouse`) - создание тестовой БД.

### Vector

__Mkdir for vector__ (Tag `mkdir_vector`) - создание директории для скачивание пакета Vector.\
__Get vector distrib__ (Tag `get_vector`) - скачивание пакета Vector.\
__Install vector package__ (Tag `install_vector`) - установка Vector.

---