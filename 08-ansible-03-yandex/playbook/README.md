# Playbook description

This playbook sets up the Clickhouse DBMS and the Vector on two remote hosts for store logs from Vector host into Clickhouse database.
In addition playbook install lightweight interface Lighthouse to

## GROUP VARS

___

### All

| variable | description |
|:---|:---|
| _ssh_port_ | ssh port on remote hosts |
| _ssh_pkey_file_ | path to ssh privatekey file |
| _sudo_user_ | server user which used for ssh connections |
| _sudo_pass_ | password of server user |

### Clickhouse variables

#### __Installation__

| variable | description |
|:---|:---|
| _clickhouse_version_ | define a version of the Clickhouse package for installation.|
| _clickhouse_packages_ | a list of the Clickhouse packages for downloading. |

#### __Server configuration__

| variable | description |
|:---|:---|
| _clickhouse_http_port_ | http port (default 8123). |
| _clickhouse_tcp_port_ | tcp port (default 9000). |
| _clickhouse_interserver_http_ | Inter-server communication port (default 9009). |
| _clickhouse_listen_host_ | listen specefied address. |
| _clickhouse_path_configdir_ | default path to configuration directory. |
| _clickhouse_path_user_files_ | path to custom user configuration files. |
| _clickhouse_path_data_ | path to clickhouse libraries. |
| _clickhouse_path_tmp_ | directory for temporary files. |
| _clickhouse_path_logdir_ | path to log files. |
| _clickhouse_service_ | name of clickhouse service. |

#### __User configuration__

| variable | description |
|:---|:---|
| _clickhouse_networks_default_ | define networks from default clickhouse user can connect to databases. |
| _clickhouse_networks_custom_ | define networks from custom clickhouse users can connect to databases (like vector user). |
| _clickhouse_users_default_ | define default user presettings. |
| _clickhouse_users_custom_ | define custom user presettings. |
| _clickhouse_profiles_default_ | define default profile presettings. |
| _clickhouse_profiles_custom_ | define custom profile presettings. |
| _clickhouse_quotas_intervals_default_ | define base quotas set. |
| _clickhouse_quotas_default_ | define quotas for default user. |
| _clickhouse_quotas_custom_ | define quotas for custom user. |
| _lighthouse_user_ | user for connections from lighthouse. |
| _lighthouse_pass_ | pass for lighthouse user. |
| _vector_user_ | user for connections from vector. |
| _vector_pass_ | pass for vecto user. |

### Vector variables

#### __Installation__

| variable | description |
|:---|:---|
| _vector_version_ | a version of the Vector. |
| _vector_package_ | a name of the Vector. |
| _os_architecture_ | an OS instruction set. |

#### __Configuration__

| variable | description |
|:---|:---|
| _vector_config_dir_ | default directory for vector configurations. |
| _vector_config_ | clickhouse connection and data sharing ssettings. |

### Lighthouse variables

#### __Installation__

| variable | description |
|:---|:---|
| _lighthouse_vcs_ | link to github project. |
| _lighthouse_dir_ | a folder where lighthouse will be pulled. |

#### __Configuration__

| variable | description |
|:---|:---|
| _nginx_user_name_ | default nginx username in nginx.conf file.|
| _nginx_default_port_ | set default nginx http port. |
| _lighthouse_port_ | set default lighthouse http port.|

## Playbook tasks

___

### Clickhouse

Play `Install clickhouse` deploys the Clickhouse on your server, create custom server and users configs, then creates database and table for logs transfer from vector host for custom user.

__Clickhouse | Get distrib__ (Tag `get_clickhouse`) - download packages clickhouse-server, clickhouse-client, clickhouse-common.\
__Clickhouse | Install packages__ (Tag `start_clickhouse`) - deploy the Clickhouse.\
__Clickhouse | Generate users config__ (Tag `configure_clickhouse`) - create users.xml config file in users.d. File based on [clickhouse.users.j2](templates/clickhouse.users.j2) template.\
__Clickhouse | Generate server config__ (Tag `configure_clickhouse`) - create config.xml config file in config.d. File based on [clickhouse.config.j2](templates/clickhouse.config.j2) template.\
__Clickhouse | Create database and table__ (Tag `configure_clickhouse`) - create test database (`logs`) and table for vector logs (for syslog as an example - `vector_logs`). In addition this task defines vector and lighthouse users.\
__Start clickhouse service__ - handler which start/restart Clickhouse service.

### Vector

Play `Install vector` deploys the Vector on your server, create custom vector config,  then launchs vector service. With this config server push its syslog to clickhouse database from previous play.

__Vector | Install package__ (Tag `install_vector`) - create directory for the Vector package.\
__Vector | Generate config__ (Tag `configure_vector`)- generate Vector .yml config file in /etc/vector directory from [vector.yml.j2](templates/vector.yml.j2) template.\
__Vector | Configure service__ (Tag `configure_vector`) - create vector.service. Based on [vector.service.j2](templates/vector.service.j2) template.\
__Start vector service__ - handler which start/restart Vector service.

### Lighthouse

Play `Install nginx` install and configure nginx on lighthouse server. Play `Install lighthouse` pull lighthouse distributive and start nginx service.

__Nginx | Install epel-release__ (Tag `get_nginx`) - install EPEL repository on Centos server.\
__Nginx | Install nginx__ - (Tag `get_nginx`) - install nginx.\
__Nginx | Generate config__ (Tag `config_nginx`) - edit nginx.conf file.\
__Start nginx service__ - handler starts nginx service.\
__Reload nginx service__ - handler reloads nginx service after configuration changes.\
__Lighthouse | Install dependencies (git)__ (Tag `install_git`)- pre-task for git installation.\
__Lighthouse | Copy from git__ (Tag `get_lighthouse`) - pull lighthouse from github.\
__Lighthouse | Create config__ (Tag `configure_lighthouse`) - create .conf file in nginx directory.

___
