# Домашнее задание к занятию "3. Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.

### Ответ

Вместо одного play создал два - play на установку nginx и play на установку lighthouse.

<details>
<summary>
Nginx and lighthouse plays
</summary>

```yml
# Play nginx installation
- name: Install nginx
  hosts: lighthouse
  handlers:
    - name: Start nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: started

    - name: Reload nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: reloaded

  tasks:
    - name: Nginx | Install epel-release
      become: true
      ansible.builtin.yum:
        name: epel-release
        state: present

    - name: Nginx | Install nginx
      become: true
      ansible.builtin.yum:
        name: nginx
        state: present
      notify: Start nginx service

    - name: Nginx | Generate config
      become: true
      become_method: sudo
      ansible.builtin.template:
        src: templates/nginx.config.j2
        dest: /etc/nginx/nginx.conf
        owner: root
        group: root
        mode: 0644
        force: true
      notify: Reload nginx service

# Play lighthouse installation
- name: Install lighthouse
  hosts: lighthouse
  handlers:
    - name: Reload nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: reloaded

  pre_tasks:
    - name: Lighthouse | Install dependencies (git)
      become: true
      ansible.builtin.yum:
        name: git
        state: present

  tasks:
    - name: Lighthouse | Copy from git
      become: true
      become_method: sudo
      ansible.builtin.git:
        repo: "{{ lighthouse_vcs }}"
        version: master
        dest: "{{ lighthouse_dir }}"

    - name: Lighthouse | Create config
      become: true
      ansible.builtin.template:
        src: templates/lighthouse.config.j2
        dest: /etc/nginx/conf.d/lighthouse.conf
        mode: 0644
      notify: Reload nginx service
```

</details>

___

4. Приготовьте свой собственный inventory файл `prod.yml`.

### Ответ

Выполено:

<details>

```yml
---
# lighthouse host (yandex cloud)
lighthouse:
  hosts:
    lighthouse-01:
      ansible_connection: ssh
      ansible_host: 158.160.46.194
      ansible_port: "{{ ssh_port }}"
      ansible_ssh_private_key_file: "{{ ssh_pkey_file }}"
      ansible_user: "{{ sudo_user }}"
      ansible_sudo_pass: "{{ sudo_pass }}"

# clickhouse host (yandex cloud)
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: ssh
      ansible_host: 158.160.45.159
      ansible_port: "{{ ssh_port }}"
      ansible_ssh_private_key_file: "{{ ssh_pkey_file }}"
      ansible_user: "{{ sudo_user }}"
      ansible_sudo_pass: "{{ sudo_pass }}"
      
# vector host (yandex cloud)
vector:
  hosts:
    vector-01:
      ansible_connection: ssh
      ansible_host: 158.160.49.91
      ansible_port: "{{ ssh_port }}"
      ansible_ssh_private_key_file: "{{ ssh_pkey_file }}"
      ansible_user: "{{ sudo_user }}"
      ansible_sudo_pass: "{{ sudo_pass }}"
```

</details>

___

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

### Ответ

Выполнено:
<details>

```bash
13:30:12 | ~/netology/netology_ci/08-ansible-03-yandex/playbook [main]
\(vainoord) $> ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass --check
Vault password: 

PLAY [Install nginx] ************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************
The authenticity of host '158.160.46.194 (158.160.46.194)' can't be established.
ED25519 key fingerprint is SHA256:kXoYLDsE0nEhd4Bohn3QTLiuCH6YB7e37W3ZT244a6k.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [lighthouse-01]

TASK [Nginx | Install epel-release] *********************************************************************************************************
changed: [lighthouse-01]

TASK [Nginx | Install nginx] ****************************************************************************************************************
fatal: [lighthouse-01]: FAILED! => {"changed": false, "msg": "No package matching 'nginx' found available, installed or updated", "rc": 126, "results": ["No package matching 'nginx' found available, installed or updated"]}

PLAY RECAP **********************************************************************************************************************************
lighthouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

```

</details>

___

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

### Ответ

Выполнено. Результат работы playbook:

```bash
PLAY RECAP **********************************************************************************************************************************
clickhouse-01              : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=11   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Полный вывод:

<details>
    <summary>
        Вывод ansible-playbook
    </summary>

```bash
    13:32:50 | ~/netology/netology_ci/08-ansible-03-yandex/playbook [main]
\(vainoord) $> ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass --diff
Vault password: 

PLAY [Install nginx] ************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************
ok: [lighthouse-01]

TASK [Nginx | Install epel-release] *********************************************************************************************************
changed: [lighthouse-01]

TASK [Nginx | Install nginx] ****************************************************************************************************************
changed: [lighthouse-01]

TASK [Nginx | Generate config] **************************************************************************************************************
--- before: /etc/nginx/nginx.conf
+++ after: /Users/vainoord/.ansible/tmp/ansible-local-99945txpb6tb7/tmph9tj1rik/nginx.config.j2
@@ -1,8 +1,6 @@
-# For more information on configuration, see:
-#   * Official English Documentation: http://nginx.org/en/docs/
-#   * Official Russian Documentation: http://nginx.org/ru/docs/
+# For more information on configuration, see: http://nginx.org/en/docs/
 
-user nginx;
+user  nginx;
 worker_processes auto;
 error_log /var/log/nginx/error.log;
 pid /run/nginx.pid;
@@ -25,7 +23,7 @@
     tcp_nopush          on;
     tcp_nodelay         on;
     keepalive_timeout   65;
-    types_hash_max_size 4096;
+    types_hash_max_size 2048;
 
     include             /etc/nginx/mime.types;
     default_type        application/octet-stream;
@@ -35,9 +33,11 @@
     # for more information.
     include /etc/nginx/conf.d/*.conf;
 
+    # Define default server settings and http port settings
+    # Look at the available for http ports in Centos7: semanage port -l | grep http_port_t
     server {
-        listen       80;
-        listen       [::]:80;
+        listen       8009 default_server;
+        listen       [::]:8009 default_server;
         server_name  _;
         root         /usr/share/nginx/html;
 
@@ -81,4 +81,3 @@
 #    }
 
 }
-

changed: [lighthouse-01]

RUNNING HANDLER [Start nginx service] *******************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [Reload nginx service] ******************************************************************************************************
changed: [lighthouse-01]

PLAY [Install lighthouse] *******************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install dependencies (git)] **********************************************************************************************
changed: [lighthouse-01]

TASK [Lighthouse | Copy from git] ***********************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

TASK [Lighthouse | Create config] ***********************************************************************************************************
--- before
+++ after: /Users/vainoord/.ansible/tmp/ansible-local-99945txpb6tb7/tmpyzz9rr_e/lighthouse.config.j2
@@ -0,0 +1,10 @@
+server {
+    listen    9000;
+	server_name localhost;
+	location / {
+	
+	    root /usr/share/lighthouse;
+		index index.html;
+	
+	}
+}
\ No newline at end of file

changed: [lighthouse-01]

RUNNING HANDLER [Reload nginx service] ******************************************************************************************************
changed: [lighthouse-01]

PLAY [Install clickhouse] *******************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************
The authenticity of host '158.160.45.159 (158.160.45.159)' can't be established.
ED25519 key fingerprint is SHA256:zTVKu7e0IlXswOh6qvoWMmg2VsLfGkB4NP7pC6KSG+U.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [clickhouse-01]

TASK [Clickhouse | Get distrib] *************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get distrib (common-static package)] *************************************************************************************
changed: [clickhouse-01]

TASK [Clickhouse | Install packages] ********************************************************************************************************
changed: [clickhouse-01]

TASK [Clickhouse | Generate users config] ***************************************************************************************************
--- before
+++ after: /Users/vainoord/.ansible/tmp/ansible-local-99945txpb6tb7/tmpv5nco7tn/clickhouse.users.j2
@@ -0,0 +1,85 @@
+<?xml version="1.0"?>
+<!--
+ -
+ - Ansible managed
+ -
+--> 
+<clickhouse>
+   <profiles>
+    <!-- Profiles of settings. -->
+    <!-- Default profiles. -->
+        <default>
+            <max_memory_usage>1000000000</max_memory_usage>
+            <use_uncompressed_cache>0</use_uncompressed_cache>
+            <load_balancing>random</load_balancing>
+            <max_partitions_per_insert_block>100</max_partitions_per_insert_block>
+        </default>
+        <readonly>
+            <readonly>0</readonly>
+        </readonly>
+        <!-- Default profiles end. -->
+    <!-- Custom profiles. -->
+        <default>
+            <max_memory_usage>1000000000</max_memory_usage>
+            <use_uncompressed_cache>0</use_uncompressed_cache>
+            <load_balancing>random</load_balancing>
+            <max_partitions_per_insert_block>100</max_partitions_per_insert_block>
+        </default>
+        <readonly>
+            <readonly>0</readonly>
+        </readonly>
+        <!-- Custom profiles end. -->
+    </profiles>
+
+    <!-- Users and ACL. -->
+    <users>
+    <!-- Default users. -->
+            <!-- Default user for login if user not defined -->
+        <default>
+                <password></password>
+                <networks incl="networks" replace="replace">
+                <ip>::1</ip>
+                <ip>127.0.0.1</ip>
+                </networks>
+        <profile>default</profile>
+        <quota>default</quota>
+                <access_management>1</access_management>
+                    </default>
+        <!-- Custom users. -->
+            <!-- Example of user with readonly access -->
+        <readonly>
+                <password></password>
+                <networks incl="networks" replace="replace">
+                <ip>::1</ip>
+                <ip>127.0.0.1</ip>
+                </networks>
+        <profile>readonly</profile>
+        <quota>default</quota>
+                            </readonly>
+        </users>
+
+    <!-- Quotas. -->
+    <quotas>
+        <!-- Default quotas. -->
+        <default>
+        <interval>
+        <duration>3600</duration>
+        <queries>0</queries>
+        <errors>0</errors>
+        <result_rows>0</result_rows>
+        <read_rows>0</read_rows>
+        <execution_time>0</execution_time>
+    </interval>
+        </default>
+            <vector>
+        <interval>
+        <duration>3600</duration>
+        <queries>0</queries>
+        <errors>0</errors>
+        <result_rows>0</result_rows>
+        <read_rows>0</read_rows>
+        <execution_time>0</execution_time>
+    </interval>
+        </vector>
+        </quotas>
+</clickhouse>
\ No newline at end of file

changed: [clickhouse-01]

TASK [Clickhouse | Generate server config] **************************************************************************************************
--- before
+++ after: /Users/vainoord/.ansible/tmp/ansible-local-99945txpb6tb7/tmphgnuglea/clickhouse.config.j2
@@ -0,0 +1,54 @@
+<?xml version="1.0"?>
+<!--
+ -
+ - Ansible managed
+ -
+--> 
+<clickhouse>
+    <logger>
+        <!-- Possible levels: https://github.com/pocoproject/poco/blob/develop/Foundation/include/Poco/Logger.h#L105 -->
+        <level>trace</level>
+        <log>/var/log/clickhouse-server/clickhouse-server.log</log>
+        <errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>
+        <size>100M</size>
+        <count>10</count>
+    </logger>
+    <http_port>8123</http_port>
+
+    <tcp_port>9000</tcp_port>
+
+    <!-- Default root page on http[s] server. For example load UI from https://tabix.io/ when opening http://localhost:8123 -->
+    <!--
+    <http_server_default_response><![CDATA[<html ng-app="SMI2"><head><base href="http://ui.tabix.io/"></head><body><div ui-view="" class="content-ui"></div><script src="http://loader.tabix.io/master.js"></script></body></html>]]></http_server_default_response>
+    -->
+
+    <!-- Port for communication between replicas. Used for data exchange. -->
+    <interserver_http_port>9009</interserver_http_port>
+
+
+
+    <!-- Hostname that is used by other replicas to request this server.
+         If not specified, than it is determined analoguous to 'hostname -f' command.
+         This setting could be used to switch replication to another network interface.
+      -->
+    <!--
+    <interserver_http_host>example.clickhouse.com</interserver_http_host>
+    -->
+
+    <!-- Listen specified host. use :: (wildcard IPv6 address), if you want to accept connections both with IPv4 and IPv6 from everywhere. -->
+    <!-- <listen_host>::</listen_host> -->
+    <!-- Same for hosts with disabled ipv6: -->
+    <!-- <listen_host>0.0.0.0</listen_host> -->
+    <listen_host>::</listen_host>
+
+    <!-- Path to data directory, with trailing slash. -->
+    <path>/var/lib/clickhouse</path>
+
+    <!-- Path to temporary data for processing hard queries. -->
+    <tmp_path>/var/lib/clickhouse/tmp/</tmp_path>
+
+    <!-- Path to configuration file with users, access rights, profiles of settings, quotas. -->
+    <users_config>/etc/clickhouse-server/users.d/users.xml</users_config>
+
+    <mark_cache_size>5368709120</mark_cache_size>
+</clickhouse>
\ No newline at end of file

changed: [clickhouse-01]

TASK [Flush handlers] ***********************************************************************************************************************

RUNNING HANDLER [Start clickhouse service] **************************************************************************************************
changed: [clickhouse-01]

TASK [Clickhouse | Create database and table] ***********************************************************************************************
changed: [clickhouse-01]

PLAY [Install vector] ***********************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************
The authenticity of host '158.160.49.91 (158.160.49.91)' can't be established.
ED25519 key fingerprint is SHA256:zlqkDYVfdZ2B5fRTWpDUJFr32qWSXGsY8SYciNhQhVE.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [vector-01]

TASK [Vector | Install package] *************************************************************************************************************
Selecting previously unselected package vector.
(Reading database ... 36872 files and directories currently installed.)
Preparing to unpack .../vector_0.25.1-1_amd6409yjam0h.deb ...
Unpacking vector (0.25.1-1) ...
Setting up vector (0.25.1-1) ...
systemd-journal:x:102:
changed: [vector-01]

TASK [Vector | Generate config] *************************************************************************************************************
--- before
+++ after: /Users/vainoord/.ansible/tmp/ansible-local-99945txpb6tb7/tmpm8mv8an7/vector.yml.j2
@@ -0,0 +1,22 @@
+---
+sinks:
+    to_clickhouse:
+        auth:
+            password: vector
+            strategy: basic
+            user: vector
+        compression: gzip
+        database: logs
+        endpoint: http://192.168.150.10:8123
+        healthcheck: true
+        inputs:
+        - sample_file
+        skip_unknown_fields: true
+        table: vector_logs
+        type: clickhouse
+sources:
+    sample_file:
+        include:
+        - /var/log/syslog
+        read_from: beginning
+        type: file

changed: [vector-01]

TASK [Vector | Configure service] ***********************************************************************************************************
--- before: /usr/lib/systemd/system/vector.service
+++ after: /Users/vainoord/.ansible/tmp/ansible-local-99945txpb6tb7/tmp0w_l9de2/vector.service.j2
@@ -1,19 +1,15 @@
 [Unit]
-Description=Vector
+Description=Vector Service
 Documentation=https://vector.dev
-After=network-online.target
+After=network.target
 Requires=network-online.target
 
 [Service]
-User=vector
-Group=vector
-ExecStartPre=/usr/bin/vector validate
-ExecStart=/usr/bin/vector
-ExecReload=/usr/bin/vector validate
+User=root
+Group=root
+ExecStart=/usr/bin/vector --config /etc/vector/vector.yml
 ExecReload=/bin/kill -HUP $MAINPID
-Restart=no
-AmbientCapabilities=CAP_NET_BIND_SERVICE
-EnvironmentFile=-/etc/default/vector
+Restart=always
 
 [Install]
-WantedBy=multi-user.target
+WantedBy=multi-user.target%
\ No newline at end of file

changed: [vector-01]

TASK [Flush handlers] ***********************************************************************************************************************

RUNNING HANDLER [Start vector service] ******************************************************************************************************
changed: [vector-01]

PLAY RECAP **********************************************************************************************************************************
clickhouse-01              : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=11   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


```

</details>

___

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

### Ответ

Из повторного запуска playbook видно, что все tasks выполнены, изменений нет.
Единственный task со статусом changed - это task по созданию БД в clickhouse.

```bash
PLAY RECAP **********************************************************************************************************************************
clickhouse-01              : ok=6    changed=1    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

### Ответ

[README](playbook/README.md) добавлен в директорию playbook.

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---