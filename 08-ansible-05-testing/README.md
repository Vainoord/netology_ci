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

#### Ответ

Добавлены дистрибутивы `ubuntu_2204` и `fedora_37` с драйвером vagrant. Vector не работает на centos7, centos8 более неактуален.\
Добавлены asserts на подтверждение установки Vector и на валидность конфигурационного файла `vector.yml`.

5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

#### Ответ

Выполнено.
[Ссылка](https://gitlab.com/study-sg/vector-role/-/tags/1.1.0) на тег репозитория vector с molecule.

---

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

### Ответ

Выполнено. С командой `molecule test -s compatibility --destroy always` tox выполняется с ошибкой, т.к. в molecule нет сценария с именем compatibility.

<details>
<summary>Вывод команда tox</summary>
```bash
[root@e70b8313c6ba vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.1.0,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.1.0,text-unidecode==1.3,typing_extensions==4.4.0,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.11.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='4194931173'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.1.0,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.1.0,text-unidecode==1.3,typing_extensions==4.4.0,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.11.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='4194931173'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.2.7,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.1.0,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.1.0,text-unidecode==1.3,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='4194931173'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==2.2.7,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.1.0,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.1.0,text-unidecode==1.3,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='4194931173'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
```
</details>

4. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
5. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

#### Ответ

Тесты не проходят. Причина - в podman не запускается служба vector:

```bash
RUNNING HANDLER [vector-role : Start vector service] ***************************
fatal: [fedora37]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: host"}
```

Summary прогона tox:

```bash
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
```

<details>
<summary>Лог tox</summary>

```bash
[root@87c1c3a14cc5 vector-role]# tox
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.2.7,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.1.0,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.1.0,text-unidecode==1.3,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='3954325232'
py39-ansible210 run-test: commands[0] | molecule test -s podman --destroy always
INFO     podman scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/sgurniak.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '883583149684.3683', 'results_file': '/root/.ansible_async/883583149684.3683', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="fedora37 registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: quay.io/fedora/fedora:37") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=fedora37)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=quay.io/fedora/fedora:37) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="fedora37 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=fedora37: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=fedora37)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=fedora37)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [fedora37]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | Install package Debian/Ubuntu] ********************
skipping: [fedora37]

TASK [vector-role : Vector | Install package Fedora] ***************************
changed: [fedora37]

TASK [vector-role : Vector | Generate config] **********************************
changed: [fedora37]

TASK [vector-role : Vector | Configure service] ********************************
changed: [fedora37]

RUNNING HANDLER [vector-role : Start vector service] ***************************
fatal: [fedora37]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: host"}

NO MORE HOSTS LEFT *************************************************************

PLAY RECAP *********************************************************************
fedora37                   : ok=4    changed=3    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/root/.cache/molecule/vector-role/podman/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/vector-role/molecule/podman/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '22614096306.4850', 'results_file': '/root/.ansible_async/22614096306.4850', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s podman --destroy always (exited with code 1)
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==2.2.7,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.1.0,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.1.0,text-unidecode==1.3,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='3954325232'
py39-ansible30 run-test: commands[0] | molecule test -s podman --destroy always
INFO     podman scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/sgurniak.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '216617978977.4957', 'results_file': '/root/.ansible_async/216617978977.4957', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="fedora37 registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: quay.io/fedora/fedora:37") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=fedora37)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=quay.io/fedora/fedora:37) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="fedora37 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=fedora37: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=fedora37)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=fedora37)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [fedora37]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | Install package Debian/Ubuntu] ********************
skipping: [fedora37]

TASK [vector-role : Vector | Install package Fedora] ***************************
changed: [fedora37]

TASK [vector-role : Vector | Generate config] **********************************
changed: [fedora37]

TASK [vector-role : Vector | Configure service] ********************************
changed: [fedora37]

RUNNING HANDLER [vector-role : Start vector service] ***************************
fatal: [fedora37]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: host"}

NO MORE HOSTS LEFT *************************************************************

PLAY RECAP *********************************************************************
fedora37                   : ok=4    changed=3    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/root/.cache/molecule/vector-role/podman/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/vector-role/molecule/podman/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '524987853871.6124', 'results_file': '/root/.ansible_async/524987853871.6124', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s podman --destroy always (exited with code 1)
______________________________________________________________________________________________ summary _______________________________________________________________________________________________
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
```

</details>

---

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли lighthouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории. В ответ приведите ссылки.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---