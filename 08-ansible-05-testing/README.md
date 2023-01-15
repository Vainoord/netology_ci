# Домашнее задание к занятию "5. Тестирование roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`
2. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.

#### Ответ

Выполнено. Работает, есть закомментировать `playbooks:` в `verifier:` и заккоментировать параметры `D` и `vv`:
```shell
...

driver:
  name: docker
  #options:
    #D: true
    #vv: true
    
    ...
    
    provisioner:
      name: ansible
      options:
          #vv: true
          #D: true
    
    ...

    verifier:
      name: ansible
      #playbooks:
        #verify: ../resources/tests/verify.yml
```

<details>
<summary>molecule test result</summary>

```shell
15:59:14 | ~/netology/netology_ci/08-ansible-05-testing/playbook/roles/clickhouse [main]
\(vainoord) $> molecule test -s centos_7
INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/Users/vainoord/.cache/ansible-compat/7e099f/modules:/Users/vainoord/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/Users/vainoord/.cache/ansible-compat/7e099f/collections:/Users/vainoord/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/Users/vainoord/.cache/ansible-compat/7e099f/roles:/Users/vainoord/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /Users/vainoord/.cache/ansible-compat/7e099f/roles/alexeysetevoi.clickhouse symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running centos_7 > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos_7 > lint
Traceback (most recent call last):
  File "/Users/vainoord/.pyenv/versions/3.10.8/bin/ansible-lint", line 8, in <module>
    sys.exit(_run_cli_entrypoint())
  File "/Users/vainoord/.pyenv/versions/3.10.8/lib/python3.10/site-packages/ansiblelint/__main__.py", line 344, in _run_cli_entrypoint
    sys.exit(main(sys.argv))
  File "/Users/vainoord/.pyenv/versions/3.10.8/lib/python3.10/site-packages/ansiblelint/__main__.py", line 242, in main
    result = _get_matches(rules, options)
  File "/Users/vainoord/.pyenv/versions/3.10.8/lib/python3.10/site-packages/ansiblelint/runner.py", line 235, in _get_matches
    matches.extend(runner.run())
  File "/Users/vainoord/.pyenv/versions/3.10.8/lib/python3.10/site-packages/ansiblelint/runner.py", line 166, in run
    matches.extend(self._emit_matches(files))
  File "/Users/vainoord/.pyenv/versions/3.10.8/lib/python3.10/site-packages/ansiblelint/runner.py", line 204, in _emit_matches
    for child in ansiblelint.utils.find_children(lintable):
  File "/Users/vainoord/.pyenv/versions/3.10.8/lib/python3.10/site-packages/ansiblelint/utils.py", line 226, in find_children
    for child in play_children(basedir, item, lintable.kind, playbook_dir):
  File "/Users/vainoord/.pyenv/versions/3.10.8/lib/python3.10/site-packages/ansiblelint/utils.py", line 306, in play_children
    return delegate_map[k](basedir, k, v, parent_type)
  File "/Users/vainoord/.pyenv/versions/3.10.8/lib/python3.10/site-packages/ansiblelint/utils.py", line 318, in _include_children
    if "{{" in v:  # pragma: no branch
TypeError: argument of type 'NoneType' is not iterable
/bin/bash: line 2: flake8: command not found
WARNING  Retrying execution failure 127 of: y a m l l i n t   . 
 a n s i b l e - l i n t 
 f l a k e 8 

CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos_7 > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

</details>

---

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

#### Ответ

<details>
<summary></summary>

```shell
16:07:09 | ~/netology/netology_ci/08-ansible-05-testing/playbook/roles/vector [main]
\(vainoord) $> molecule init scenario default --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /Users/vainoord/netology/netology_ci/08-ansible-05-testing/playbook/roles/vector/molecule/default successfully.

```

</details>

---

3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

### Ответ

Добавлены дистрибутивы `ubuntu_2204` и `fedora_37` с драйвером vagrant. Vector не работает на centos7, centos8 более неактуален.

5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли lighthouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории. В ответ приведите ссылки.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---