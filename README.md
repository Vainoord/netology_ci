# Домашнее задание к занятию "2. Работа с Playbook"

## Алгоритм выполнения ДЗ

### __Подготовка хостов__

1. Создать в YC директорию, сеть и подсеть (например `192.168.150.0/26`).
2. В скрипте [encrypt!.sh](terraform/yc/packer/encrypt!.sh) прописать пароль будущего пользователя удаленных хостов `PASS=` и публичный ключ ssh `SSH=`.
3. Запустить скрипт `encrypt!.sh`, в директории `terraform/yc/packer/` будут созданы по два зашифрованных файла для debian и centos.
4. В файлы `debian.json` и `centos.json` задать параметры:

   - token учетной записи
   - folder_id учетной записи
   - zone
   - subnet_id из п.1

5. Запустить создание образов: `packer build debian.json`, `packer build centos.json`. VM с debian будет использована для Vector, а Centos для Clickhouse.
6. В файле [variables.tf](terraform/yc/variables.tf) задать:
   - yandex_token
   - yandex_cloud_id
   - yandex_folder_id
   - my-centos-7 - id образа centos с п.5
   - my-debian-11 - id образа debian с п.5
   - yandex_zone
   - subnet-id из п.1

7. Запустить из директории [terraform](terraform/yc/) создание VMs через `terraform init`, `terraform plan`, `terraform apply`.\
Получить из outputs IP адреса машин:

```bash
Outputs:

clickhouse-01_local_ip_address = "192.168.150.10"
clickhouse-01_public_ip_address = "51.250.4.10"
vector-01_local_ip_address = "192.168.150.23"
vector-01_public_ip_address = "51.250.67.44"
```

### __Запуск playbook__

1. В файле с переменными для vector [vars.yml](playbook/group_vars/vector/vars.yml) установить `endpoint` на локальный ip адрес clickhouse и порт 8123, например:\
 `endpoint: http://192.168.150.10:8123`
2. В файле [prod.yml](playbook/inventory/prod.yml) поменять значения `ansible_host`, `ansible_ssh_private_key_file` на свои для групп clickhouse (vm с centos используется для clickhouse) и vector (vm с debian используется для vector).
3. Запустить ansible playbook site.yml с inventory prod.yml. Во время запуска подтвердить использование ssh ключей для подключения к каждому хосту.

### __Ошибки__

После выполнения playbook результат следующий:

```bash
PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

На сервере с Clickhouse служба clickhouse-server запущена:
```bash
[root@clickhouse-01 netology]# systemctl status clickhouse-server
● clickhouse-server.service - ClickHouse Server (analytic DBMS for big data)
   Loaded: loaded (/usr/lib/systemd/system/clickhouse-server.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2022-12-07 14:02:02 UTC; 4min 20s ago
 Main PID: 2404 (clckhouse-watch)
   CGroup: /system.slice/clickhouse-server.service
           ├─2404 clickhouse-watchdog --config=/etc/clickhouse-server/config.xml --pid-file=/run/clickhouse-server/clickhouse-server.pid
           └─2405 /usr/bin/clickhouse-server --config=/etc/clickhouse-server/config.xml --pid-file=/run/clickhouse-server/clickhouse-server.pid

...
```

БД `logs`, таблица `vector_logs` и пользователь `vector` созданы:

```bash
[root@clickhouse-01 netology]# clickhouse-client -u vector --pass
ClickHouse client version 22.3.3.44 (official build).
Password for user (vector): 
Connecting to localhost:9000 as user vector.
Connected to ClickHouse server version 22.3.3 revision 54455.

clickhouse-01.yc.local :) show databases;

SHOW DATABASES

Query id: c26df354-da18-4068-88b9-2f0dda60850a

┌─name─┐
│ logs │
└──────┘

1 rows in set. Elapsed: 0.002 sec. 

clickhouse-01.yc.local :) select * from logs.vector_logs;

SELECT *
FROM logs.vector_logs

Query id: 37c8437b-ae32-463d-a6c3-4178bd264dcd

Ok.

0 rows in set. Elapsed: 0.002 sec. 
```

На сервер с Vector служба vector не запущена:

```bash
root@vector-01:/home/netology# systemctl status vector
● vector.service - Vector Service
     Loaded: loaded (/etc/systemd/system/vector.service; static)
     Active: failed (Result: exit-code) since Wed 2022-12-07 14:02:47 UTC; 8min ago
    Process: 1110 ExecStart=/usr/bin/vector --config-yaml /etc/vector/vector.yml --watch-config (code=exited, status=78)
   Main PID: 1110 (code=exited, status=78)
        CPU: 51ms

Dec 07 14:02:47 vector-01 systemd[1]: vector.service: Scheduled restart job, restart counter is at 5.
Dec 07 14:02:47 vector-01 systemd[1]: Stopped Vector Service.
Dec 07 14:02:47 vector-01 systemd[1]: vector.service: Start request repeated too quickly.
Dec 07 14:02:47 vector-01 systemd[1]: vector.service: Failed with result 'exit-code'.
Dec 07 14:02:47 vector-01 systemd[1]: Failed to start Vector Service.
```

Запуск вручную так же не работает:

```bash
root@vector-01:/home/netology# /usr/bin/vector --config-yaml /etc/vector/vector.yml --watch-config
2022-12-07T14:14:32.859211Z  INFO vector::app: Internal log rate limit configured. internal_log_rate_secs=10
2022-12-07T14:14:32.860390Z  INFO vector::app: Log level is enabled. level="vector=info,codec=info,vrl=info,file_source=info,tower_limit=trace,rdkafka=info,buffers=info,lapin=info,kube=info"
2022-12-07T14:14:32.860539Z  INFO vector::config::watcher: Creating configuration file watcher.
2022-12-07T14:14:32.862735Z  INFO vector::config::watcher: Watching configuration files.
2022-12-07T14:14:32.863548Z  INFO vector::app: Loading configs. paths=["/etc/vector/vector.yml"]
2022-12-07T14:14:32.889026Z  INFO vector::topology::running: Running healthchecks.
2022-12-07T14:14:32.889334Z  INFO vector: Vector has started. debug="false" version="0.25.1" arch="x86_64" revision="9125a99 2022-11-07"
2022-12-07T14:14:32.889393Z  INFO vector::app: API is disabled, enable by setting `api.enabled` to `true` and use commands like `vector top`.
2022-12-07T14:14:32.889567Z  INFO source{component_kind="source" component_id=sample_file component_type=file component_name=sample_file}: vector::sources::file: Starting file server. include=["/var/log/dpkg.log"] exclude=[]
2022-12-07T14:14:32.892051Z  INFO source{component_kind="source" component_id=sample_file component_type=file component_name=sample_file}:file_server: file_source::checkpointer: Attempting to read legacy checkpoint files.
2022-12-07T14:14:32.894422Z  INFO vector::topology::builder: Healthcheck: Passed.
2022-12-07T14:14:32.899455Z  INFO source{component_kind="source" component_id=sample_file component_type=file component_name=sample_file}:file_server: vector::internal_events::file::source: Found new file to watch. file=/var/log/dpkg.log
2022-12-07T14:14:33.912252Z ERROR sink{component_kind="sink" component_id=to_clickhouse component_type=clickhouse component_name=to_clickhouse}:request{request_id=0}: vector::sinks::util::retries: Not retriable; dropping the request. reason="response status: 400 Bad Request" internal_log_rate_limit=true
2022-12-07T14:14:33.912342Z ERROR sink{component_kind="sink" component_id=to_clickhouse component_type=clickhouse component_name=to_clickhouse}:request{request_id=0}: vector::sinks::util::sink: Response failed. response=Response { status: 400, version: HTTP/1.1, headers: {"date": "Wed, 07 Dec 2022 14:14:33 GMT", "connection": "Keep-Alive", "content-type": "text/plain; charset=UTF-8", "x-clickhouse-server-display-name": "clickhouse-01.yc.local", "transfer-encoding": "chunked", "x-clickhouse-exception-code": "117", "keep-alive": "timeout=3", "x-clickhouse-summary": "{\"read_rows\":\"0\",\"read_bytes\":\"0\",\"written_rows\":\"0\",\"written_bytes\":\"0\",\"total_rows_to_read\":\"0\"}"}, body: b"Code: 117. DB::Exception: Unknown field found while parsing JSONEachRow format: source_type: (at row 1)\n: While executing JSONEachRowRowInputFormat. (INCORRECT_DATA) (version 22.3.3.44 (official build))\n" }
2022-12-07T14:14:33.912421Z ERROR sink{component_kind="sink" component_id=to_clickhouse component_type=clickhouse component_name=to_clickhouse}:request{request_id=0}: vector_common::internal_event::service: Service call failed. No retries or retries exhausted. error="Response failed." request_id=0 error_type="request_failed" stage="sending" internal_log_rate_limit=true
2022-12-07T14:14:33.912455Z ERROR sink{component_kind="sink" component_id=to_clickhouse component_type=clickhouse component_name=to_clickhouse}:request{request_id=0}: vector_common::internal_event::component_events_dropped: Events dropped intentional=false count=601 reason="Service call failed. No retries or retries exhausted." internal_log_rate_limit=true
```

---
