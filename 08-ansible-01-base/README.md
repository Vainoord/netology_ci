# Домашнее задание к занятию "1. Введение в Ansible"

## Подготовка к выполнению

1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

   ### Ответ

   ```{bash}
   TASK [Print OS] ***************************************************************************************************
   ok: [localhost] => {
       "msg": "MacOSX"
   }
   
   TASK [Print fact] *************************************************************************************************
   ok: [localhost] => {
       "msg": 12
   }
   ```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

   ### Ответ

   ```{bash}
   16:29:58 | ~/netology/netology_ci [main]
   \-bash (vainoord) $> cat playbook/group_vars/all/examp.yml
   ---
    some_fact: all default fact
   ```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

   ### Ответ

   Созданы контейнеры по образам ubuntu и centos7:

   ```{bash}
   18:37:57 | ~/netology/netology_ci [main]
   \(vainoord) $> docker ps
   CONTAINER ID   IMAGE            COMMAND       CREATED          STATUS          PORTS     NAMES
   971b0c2d2afa   ubuntu:latest    "bash"        24 minutes ago   Up 24 minutes             ubuntu
   77f32023f228   centos:centos7   "/bin/bash"   36 minutes ago   Up 33 minutes             centos7
   ```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

   ### Ответ

   ```{bash}
   PLAY [Print os facts] *******************************************************************************************************************************************************

   TASK [Gathering Facts] ******************************************************************************************************************************************************
   ok: [ubuntu]
   ok: [centos7]

   TASK [Print OS] *************************************************************************************************************************************************************
   ok: [centos7] => {
       "msg": "CentOS"
   }
   ok: [ubuntu] => {
       "msg": "Ubuntu"
   }

   TASK [Print fact] ***********************************************************************************************************************************************************
   ok: [centos7] => {
       "msg": "el"
   }
   ok: [ubuntu] => {
       "msg": "deb"
   }

   PLAY RECAP ******************************************************************************************************************************************************************
   centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
   ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
   ```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

    ### Ответ

    Сообщение в `facts` обновлены:

    ```{bash}
    19:47:48 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-playbook playbook/site.yml -i playbook/inventory/prod.yml

    PLAY [Print os facts] *******************************************************************************************************************************************************

    TASK [Gathering Facts] ******************************************************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] *************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }

    TASK [Print fact] ***********************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }

    PLAY RECAP ******************************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
    ```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

    ### Ответ

    Факты зашифрованы:

    ```{bash}
    07:40:17 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-vault encrypt playbook/group_vars/deb/examp.yml 
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful

    07:41:01 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-vault encrypt playbook/group_vars/el/examp.yml 
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful

    07:44:30 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-playbook playbook/site.yml -i playbook/inventory/prod.yml --ask-vault-pass
    Vault password: 

    PLAY [Print os facts] ************************************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ******************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }

    TASK [Print fact] ****************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }

    PLAY RECAP ***********************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ```

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

    ### Ответ

    Список модулей для `connection`. Нам подойдет модуль `local`:

    ```{bash}
    15:15:22 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-doc -l -t connection
    ansible.netcommon.grpc         Provides a persistent connection using the gRPC protocol                                      
    ansible.netcommon.httpapi      Use httpapi to run command on network appliances                                              
    ansible.netcommon.libssh       Run tasks using libssh for ssh connection                                                     
    ansible.netcommon.napalm       Provides persistent connection using NAPALM                                                   
    ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol                                   
    ansible.netcommon.network_cli  Use network_cli to run command on network appliances                                          
    ansible.netcommon.persistent   Use a persistent unix socket for connection                                                   
    community.aws.aws_ssm          execute via AWS Systems Manager                                                               
    community.docker.docker        Run tasks in docker containers                                                                
    community.docker.docker_api    Run tasks in docker containers                                                                
    community.docker.nsenter       execute on host running controller container                                                  
    community.general.chroot       Interact with local chroot                                                                    
    community.general.funcd        Use funcd to connect to target                                                                
    community.general.iocage       Run tasks in iocage jails                                                                     
    community.general.jail         Run tasks in jails                                                                            
    community.general.lxc          Run tasks in lxc containers via lxc python library                                            
    community.general.lxd          Run tasks in lxc containers via lxc CLI                                                       
    community.general.qubes        Interact with an existing QubesOS AppVM                                                       
    community.general.saltstack    Allow ansible to piggyback on salt minions                                                    
    community.general.zone         Run tasks in a zone instance                                                                  
    community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt                                                       
    community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines                                                    
    community.okd.oc               Execute tasks in pods running on OpenShift                                                    
    community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools                                                    
    community.zabbix.httpapi       Use httpapi to run command on network appliances                                              
    containers.podman.buildah      Interact with an existing buildah container                                                   
    containers.podman.podman       Interact with an existing podman container                                                    
    kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes                                                   
    local                          execute on controller                                                                         
    paramiko_ssh                   Run tasks via python ssh (paramiko)                                                           
    psrp                           Run tasks over Microsoft PowerShell Remoting Protocol                                         
    ssh                            connect via SSH client binary                                                                 
    winrm                          Run tasks over Microsoft's WinRM 
    ```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

    ### Ответ

    ```{yml}
    ---
    el:
        hosts:
        centos7:
            ansible_connection: docker
    deb:
        hosts:
        ubuntu:
            ansible_connection: docker
    local:
        hosts:
        localhost:
            ansible_connection: local
    ```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

    ### Ответ
    Выполнено:

    ```{bash}
    15:15:26 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-playbook playbook/site.yml -i playbook/inventory/prod.yml --ask-vault-pass
    Vault password: 

    PLAY [Print os facts] ************************************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************************************
    [WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /usr/local/bin/python3.10, but future
    installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
    core/2.13/reference_appendices/interpreter_discovery.html for more information.
    ok: [localhost]
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ******************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [localhost] => {
        "msg": "MacOSX"
    }

    TASK [Print fact] ****************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ok: [localhost] => {
        "msg": "all default fact"
    }

    PLAY RECAP ***********************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

   ### Ответ

   ```{yml}
   ---
     some_fact: !vault |
             $ANSIBLE_VAULT;1.1;AES256
             62373562313536326130343330323635633264323336386235353166663463383231336566623565
             3130616230363435323338663035353234636463393735630a346331653964613137623739326130
             39376661323566346131386533393939376632343734663161336631313362313138316631383632
             6438656431363531370a643031383036633462326438396436336565653661303865623137646564
             6534
   ```

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

    ### Ответ

    ```{bash}
    23:16:26 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-playbook playbook/site.yml -i playbook/inventory/prod.yml --ask-vault-pass
    Vault password: 

    PLAY [Print os facts] ************************************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************************************
    [WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /usr/local/bin/python3.10, but future
    installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
    core/2.13/reference_appendices/interpreter_discovery.html for more information.
    ok: [localhost]
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ******************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [localhost] => {
        "msg": "MacOSX"
    }

    TASK [Print fact] ****************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ok: [localhost] => {
        "msg": "PaSSw0rd"
    }

    PLAY RECAP ***********************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

    ### Ответ

    ```{bash}
    21:18:27 | ~/netology/netology_ci [main]
    \(vainoord) $> ansible-playbook playbook/site.yml -i playbook/inventory/prod.yml --ask-vault-pass
    Vault password: 

    PLAY [Print os facts] ************************************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************************************
    [WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /usr/local/bin/python3.10, but future
    installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
    core/2.13/reference_appendices/interpreter_discovery.html for more information.
    ok: [localhost]
    ok: [fedora]
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ******************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [localhost] => {
        "msg": "MacOSX"
    }
    ok: [fedora] => {
        "msg": "Fedora"
    }

    TASK [Print fact] ****************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ok: [fedora] => {
        "msg": "fed default fact"
    }
    ok: [localhost] => {
        "msg": "PaSSw0rd"
    }

    PLAY RECAP ***********************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
    ```

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

    ### Ответ
    
    Добавлен файл [script.sh](playbook/script.sh) в корень проекта. Скрипт запускает скачивание докер-образов, создает и запускает контейнеры, затем запускает playbook и после выполнения всех play удаляет контейнеры.
    
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
