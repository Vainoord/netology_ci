# Playbook description

This playbook sets up the Clickhouse DBMS and the Vector to transfer data on two docker containers. Each container will keep one application.

## GROUP VARS

### Clickhouse variables

#### __Installation__

_clickhouse_version_ - define a version of the Clickhouse package for installation.\
_clickhouse_packages_ - a list of the Clickhouse packages for downloading.

#### __Server configuration__

_clickhouse_http_port_ - http port (default 8123).\
_clickhouse_tcp_port_ - tcp port (default 9000).\
_clickhouse_interserver_http_ - Inter-server communication port (default 9009).\
_clickhouse_listen_host_ - listen specefied address.

_clickhouse_path_configdir_ - default path to configuration directory.\
_clickhouse_path_user_files_ - path to custom user configuration files.\
_clickhouse_path_data_ - path to clickhouse libraries.\
_clickhouse_path_tmp_ - directory for temporary files.\
_clickhouse_path_logdir_ - path to log files.\
_clickhouse_service_ - name of clickhouse service.

#### __User configuration__

_clickhouse_networks_default_ - define networks from default clickhouse user can connect to databases.\
_clickhouse_networks_custom_ - define networks from custom clickhouse users can connect to databases (like vector user).\
_clickhouse_users_default_ - define default user presettings.\
_clickhouse_users_custom_ - define custom user presettings.\
_clickhouse_profiles_default_ - define default profile presettings.\
_clickhouse_profiles_custom_ - define custom profile presettings.\
_clickhouse_quotas_intervals_default_ - define base quotas set.\
_clickhouse_quotas_default_ - define quotas for default user.\
_clickhouse_quotas_custom_ - define quotas for custom user.

### Vector variables

#### __Installation__

_vector_version_ - a version of the Vector.\
_vector_package_ - a name of the Vector.\
_os_architecture_ - an OS instruction set.

#### __Configuration__

_vector_config_dir_ - default directory for vector configurations.\
_vector_config_ - clickhouse connection and data sharing ssettings.\

## Playbook tasks

### Clickhouse

__Get clickhouse distrib__ (Tag `start_clickhouse`) - download packages clickhouse-server, clickhouse-client, clickhouse-common.\
__Install clickhouse packages__ (Tag `get_clickhouse`) - deploy the Clickhouse.\
__Generate users config__ (Tag `configure_clickhouse`) - create users.xml config file in users.d.\
__Generate server config__ (Tag `configure_clickhouse`) - create config.xml config file in config.d.\
__Start clickhouse server__ (Tag `install_clickhouse`) - launch clickhouse-server process.\
__Generate users config__ (Tag `configure_clickhouse`) - generate users.xml file with Clickhouse users.\
__Create database and table__ (Tag `configure_clickhouse`) - create test database as an example.

### Vector

__Install vector package | Debian__ (Tag `install_vector`) - create directory for the Vector package.\
__Configure service | Template systemd unit__ (Tag `configure_vector`) - create vector.service.\
__Configure Vector | ensure that directory exists__ (Tag `configure_vector`)- check default directory /etc/vector.\
__Configure Vector | Template config__ (Tag `configure_vector`, `install_vector`) - create clickhouse data transfer config.

---
