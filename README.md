# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

    ### Ответ

    Подготовлены docker контейнеры с centos7 под clickhouse и debian11 под vector
## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

    ### Ответ

    Готово. Использую docker-контейнеры в качестве тестовой среды:

    ```{yml}
    ---
    # clickhouse host (in docker container)
    clickhouse:
    hosts:
        clickhouse-01:
        ansible_connection: docker
    # vector host (in docker container)
    vector:
    hosts:
        vector-01:
        ansible_connection: docker
    ```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

    ### Ответ

    Поменял collection в handler. Вместо `ansible.builtin.service` поставил `ansible.builtin.command`, т.к. в контейнере с Centos7 не работал перезапуск службы через `systemctl`. Также написал play с развертывание контейнеров. В итоге play с запуском контейнеров работает, play с установкой и настройкой clickhouse не работает. При добавлении файла `users.xml` в директорию clickhouse `/etc/clickhouse-server/users.d/` сервер не запускается. Файл `user.xml` генерится через шаблон, который был взят отсюда: https://github.com/AlexeySetevoi/ansible-clickhouse

    Содержимое site.yml:

    ```{yml}
    ---
    # Play containers deploying
    - name: Deploy containers
    hosts: local
    handlers:
    tasks:
        - name: Create docker network
        community.docker.docker_network:
            name: my_net
        tags:
            - docker_network

        - name: Create Centos image
        community.docker.docker_image:
            name: my_centos
            tag: "7"
            build:
            path: ../docker/Centos/
            rm: true
            source: build
            state: present
        tags:
            - run_clickhouse_container

        - name: Create Debian image
        community.docker.docker_image:
            name: my_debian
            tag: "11"
            build:
            path: ../docker/Debian/
            rm: true
            source: build
            state: present
        tags:
            - run_vector_container

        - name: Run Centos container
        community.docker.docker_container:
            name: clickhouse-01
            image: my_centos:7
            networks:
            - name: my_net
            published_ports:
            - 0.0.0.0:8123:8123
            - 0.0.0.0:9000:9000
            - 0.0.0.0:9004:9004
            - 0.0.0.0:9005:9005
            - 0.0.0.0:9009:9009
            state: started
            detach: true
            tty: true
            interactive: true
        tags:
            - run_clickhouse_container

        - name: Run Debian container
        community.docker.docker_container:
            name: vector-01
            image: my_debian:11
            networks:
            - name: my_net
            state: started
            detach: true
            tty: true
            interactive: true
        tags:
            - run_vector_container

    # Play clickhouse installation
    - name: Install Clickhouse
    hosts: clickhouse
    handlers:
        - name: Start clickhouse server
        become: true
        ansible.builtin.command:
            cmd: /etc/init.d/clickhouse-server start && sleep 5
        tags:
            - start_clickhouse

    tasks:
        - name: Get clickhouse distrib
        block:
            - name: Get clickhouse distrib
            ansible.builtin.get_url:
                url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
                dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
                mode: '0776'
            with_items: "{{ clickhouse_packages }}"
            tags:
                - get_clickhouse
        rescue:
            - name: Get clickhouse distrib (common-static package)
            ansible.builtin.get_url:
                url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
                dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
                mode: '0776'
            tags:
                - get_clickhouse

        - name: Install clickhouse packages
        become: true
        ansible.builtin.yum:
            name:
            - yum-utils
            - clickhouse-common-static-{{ clickhouse_version }}.rpm
            - clickhouse-client-{{ clickhouse_version }}.rpm
            - clickhouse-server-{{ clickhouse_version }}.rpm
        tags:
            - install_clickhouse
        notify: Start clickhouse server

        - name: Generate users config
        ansible.builtin.template:
            src: users.j2
            dest: "/etc/clickhouse-server/users.d/users.xml"
            owner: "clickhouse"
            group: "clickhouse"
            mode: "ug=r,o-r"
        become: true
        tags:
            - configure_clickhouse

        - name: Flush handlers
        ansible.builtin.meta: flush_handlers

        - name: Create database
        ansible.builtin.command: "clickhouse-client --user vector --password vector -q 'create database if not exists logs;'"
        register: create_db
        failed_when: create_db.rc != 0 and create_db.rc !=82
        changed_when: create_db.rc == 0
        tags:
            - configure_clickhouse

    # Play vector installation
    - name: Install Vector
    hosts: vector
    handlers:
    tasks:
        - name: Mkdir for vector
        ansible.builtin.file:
            path: /vector
            state: directory
            mode: '0776'
        tags:
            - mkdir_vector

        - name: Get vector distrib
        ansible.builtin.get_url:
            url: "https://packages.timber.io/vector/{{ vector_version }}/{{ vector_package }}_{{ vector_version }}-1_{{ os_architecture }}.deb"
            dest: "/vector/{{ vector_package }}_{{ vector_version }}-1_{{ os_architecture }}.deb"
            mode: '0776'
        tags:
            - get_vector

        - name: Install vector package
        ansible.builtin.apt:
            deb: "/vector/{{ vector_package }}_{{ vector_version }}-1_{{ os_architecture }}.deb"
        tags:
            - install_vector
        ```

        Содержимое vars.yml для Vector:

        ```{yml}
        ---
        # a version of vector we need
        vector_version: "0.25.1"
        # package we need for vector installation
        vector_package: "vector"
        # x86_64 OS
        os_architecture: "amd64"
        #Vector configuration
        vector_config:
        sources:
            sample_file:
            type: file
            read_from: beginning
            include:
                - /var/logs/dpkg.log
        sinks:
            to_clickhouse:
            type: clickhouse
            inputs:
                # we take 'sample_file' from 'sources' above
                - sample_file
            endpoints: http://172.18.0.2:8123
            databases: logs
            table: vector_host_log
            auth:
                strategy: basic
                user: vector
                password: vector
            skin_unknown_fields: null
            compression: gzip
    ```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

    ### Ответ

    Выполнено:

    ```{bash}
    19:36:57 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-lint playbook/site.yml
    WARNING  Ignore loading rule from /usr/local/Cellar/ansible-lint/6.9.0/libexec/lib/python3.10/site-packages/ansiblelint/rules/jinja.py due to No module named 'black'
    WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: playbook/site.yml

    Passed with production profile: 0 failure(s), 0 warning(s) on 1 files.
    ```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

    ### Ответ

    ```{bash}
    PLAY [Install Clickhouse] ********************************************************************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Get clickhouse distrib] ****************************************************************************************************************************************
    ok: [clickhouse-01] => (item=clickhouse-client)
    ok: [clickhouse-01] => (item=clickhouse-server)
    failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

    TASK [Get clickhouse distrib (common-static package)] ****************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Install clickhouse packages] ***********************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Create database] ***********************************************************************************************************************************************
    skipping: [clickhouse-01]

    PLAY [Install Vector] ************************************************************************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************************************************************************
    ok: [vector-01]

    TASK [Mkdir for vector] **********************************************************************************************************************************************
    changed: [vector-01]

    TASK [Get vector distrib] ********************************************************************************************************************************************
    ok: [vector-01]

    TASK [Install vector package] ****************************************************************************************************************************************
    ok: [vector-01]

    PLAY RECAP ***********************************************************************************************************************************************************
    clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
    vector-01                  : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

    ### Ответ

    ```{bash}
    PLAY [Install Clickhouse] ********************************************************************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Get clickhouse distrib] ****************************************************************************************************************************************
    ok: [clickhouse-01] => (item=clickhouse-client)
    ok: [clickhouse-01] => (item=clickhouse-server)
    failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

    TASK [Get clickhouse distrib (common-static package)] ****************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Install clickhouse packages] ***********************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Create database] ***********************************************************************************************************************************************
    ok: [clickhouse-01]

    PLAY [Install Vector] ************************************************************************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************************************************************************
    ok: [vector-01]

    TASK [Mkdir for vector] **********************************************************************************************************************************************
    ok: [vector-01]

    TASK [Get vector distrib] ********************************************************************************************************************************************
    ok: [vector-01]

    TASK [Install vector package] ****************************************************************************************************************************************
    ok: [vector-01]

    PLAY RECAP ***********************************************************************************************************************************************************
    clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
    vector-01                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
    ```

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

    ### Ответ

    Файл добавлен в директория playbook.

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
