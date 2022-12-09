# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

    ### Ответ

    Подготовлены VM с centos7 для clickhouse и VM с debian11 для vector в yandex cloud.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

    ### Ответ

    Готово:

```yml
---
# clickhouse host (yandex cloud)
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: ssh
      ansible_host: 51.250.90.153
      ansible_port: "{{ ssh_port }}"
      ansible_ssh_private_key_file: "{{ ssh_pkey_file }}"
      ansible_user: "{{ sudo_user }}"
      ansible_sudo_pass: "{{ sudo_pass }}"
      
# vector host (yandex cloud)
vector:
  hosts:
    vector-01:
      ansible_connection: ssh
      ansible_host: 84.252.131.41
      ansible_port: "{{ ssh_port }}"
      ansible_ssh_private_key_file: "{{ ssh_pkey_file }}"
      ansible_user: "{{ sudo_user }}"
      ansible_sudo_pass: "{{ sudo_pass }}"
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

    ### Ответ

    Tasks добавлены в файл site.yml

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

    ### Ответ

    Выполнено, ошибки исправлены:

```bash
19:36:57 | ~/netology/netology_ci [main]
\(vainoord) $> ansible-lint playbook/site.yml
WARNING  Ignore loading rule from /usr/local/Cellar/ansible-lint/6.9.0/libexec/lib/python3.10/site-packages/ansiblelint/rules/jinja.py due to No module named 'black'
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: playbook/site.yml

Passed with production profile: 0 failure(s), 0 warning(s) on 1 files.
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

    ### Ответ

    Playbook валится на таске `Install clickhouse packages`, т.к. с флагом `--check` пакеты не будут скачиваться и никаких изменений на удаленных хостах производится не будут.

```bash
PLAY [Install clickhouse] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************
The authenticity of host '158.160.42.52 (158.160.42.52)' can't be established.
ED25519 key fingerprint is SHA256:cPbgEW5GflrnNG4BzVSCRTXnKm+uRZB7hmk/qY1/cuA.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [clickhouse-01]

TASK [Clickhouse | Get distrib] ********************************************************************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get distrib (common-static package)] ********************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Clickhouse | Install packages] ***************************************************************************************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["yum-utils-1.1.31-54.el7_8.noarch providing yum-utils is already installed", "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

    ### Ответ

    Есть изменения в тасках, в которых идет создание файлов конфигураций или сервисов:

    - Clickhouse | Get distrib
    - Clickhouse | Install packages
    - Clickhouse | Generate users config
    - Clickhouse | Generate server config
    - Clickhouse | Create database and table
    - Vector | Install package
    - Vector | Generate config
    - Vector | Configure service

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

    ### Ответ

    При повторном запуске playbook нет изменений в конфигурациях сервисов:

```bash
14:16:48 | ~/netology/netology_ci/terraform/yc [main]
\(vainoord) $> ansible-playbook  -i ~/netology/netology_ci/playbook/inventory/prod.yml ~/netology/netology_ci/playbook/site.yml --ask-vault-pass --diff
Vault password: 

PLAY [Install clickhouse] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Clickhouse | Get distrib] ********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1001, "group": "vainoord", "item": "clickhouse-common-static", "mode": "0776", "msg": "Request failed", "owner": "vainoord", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1001, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get distrib (common-static package)] ********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Clickhouse | Install packages] ***************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Clickhouse | Generate users config] *********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Clickhouse | Generate server config] ********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ****************************************************************************************************************************************************************************************************************************************

RUNNING HANDLER [Start clickhouse service] ***********************************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Clickhouse | Create database and table] *****************************************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install vector] ****************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Install package] ***********************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Generate config] *************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Configure service] *******************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Flush handlers] ****************************************************************************************************************************************************************************************************************************************

RUNNING HANDLER [Start vector service] ***********************************************************************************************************************************************************************************************************************
changed: [vector-01]

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=7    changed=1    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0    
```

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

    ### Ответ

    [README](playbook/README.md) добавлен в директорию playbook.

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
