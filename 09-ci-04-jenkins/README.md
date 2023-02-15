# Домашнее задание к занятию "10.Jenkins"

## Подготовка к выполнению

1. Создать 2 VM: для jenkins-master и jenkins-agent.
2. Установить jenkins при помощи playbook'a.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

#### Ответ

Выполнено:

<details>
    <summary>Git исходник задачи</summary>
    <img src="assets/scr1.png"
     alt="git source repository"
     style="float: left; margin-right: 10px;" />
</details>

<details>
    <summary>Freestyle job</summary>
    <img src="assets/scr2.png"
     alt="shell step"
     style="float: left; margin-right: 10px;" />
</details>

---

2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.

#### Ответ

Pipeline перенесен в JenkinsFile в репозиторий:\
<https://gitlab.com/study-sg/vector-role/-/blob/main/Jenkinsfile>

<details>
<summary>Log content</summary>

```shell
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on clt-01 in /opt/jenkins_agent/workspace/vector
[Pipeline] {
[Pipeline] stage
[Pipeline] { (first)
[Pipeline] sh
+ git clone https://gitlab.com/study-sg/vector-role.git .
Cloning into '.'...
[Pipeline] sh
+ python3 -m molecule test -s podman
INFO     podman scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/jenkins/.cache/ansible-compat/b0d51c/modules:/home/jenkins/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/jenkins/.cache/ansible-compat/b0d51c/collections:/home/jenkins/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/jenkins/.cache/ansible-compat/b0d51c/roles:/home/jenkins/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '854401176095.7537', 'results_file': '/home/jenkins/.ansible_async/854401176095.7537', 'changed': True, 'item': {'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

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
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: quay.io/fedora/fedora:37")
skipping: [localhost]

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=fedora37)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=quay.io/fedora/fedora:37)
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="fedora37 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=fedora37: None specified)
skipping: [localhost]

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
[WARNING]: The "podman" connection plugin has an improperly configured remote
target value, forcing "inventory_hostname" templated value instead of the
string
ok: [fedora37]

TASK [Include vector] **********************************************************

TASK [vector : Vector | Check virttype] ****************************************
[WARNING]: The "podman" connection plugin has an improperly configured remote
target value, forcing "inventory_hostname" templated value instead of the
string
ok: [fedora37] => {
    "msg": [
        "container"
    ]
}

TASK [vector : Vector | Install package Debian/Ubuntu] *************************
skipping: [fedora37]

TASK [vector : Vector | Install package Fedora] ********************************
[WARNING]: The "podman" connection plugin has an improperly configured remote
target value, forcing "inventory_hostname" templated value instead of the
string
changed: [fedora37]

TASK [vector : Vector | Generate config] ***************************************
[WARNING]: The "podman" connection plugin has an improperly configured remote
target value, forcing "inventory_hostname" templated value instead of the
string
changed: [fedora37]

TASK [vector : Vector | Configure service] *************************************
[WARNING]: The "podman" connection plugin has an improperly configured remote
target value, forcing "inventory_hostname" templated value instead of the
string
changed: [fedora37]

TASK [vector : Flush handlers] *************************************************

RUNNING HANDLER [vector : Start vector service] ********************************
skipping: [fedora37]

PLAY RECAP *********************************************************************
fedora37                   : ok=5    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '196592371668.9064', 'results_file': '/home/jenkins/.ansible_async/196592371668.9064', 'changed': True, 'item': {'image': 'quay.io/fedora/fedora:37', 'name': 'fedora37', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

</details>

---

4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.

#### Ответ

Multibranch pipeline создан.

<details>
    <summary>Scan Multibranch Pipeline Log</summary>

```shell
Started
[Mon Feb 13 23:13:34 UTC 2023] Starting branch indexing...
 > git --version # timeout=10
 > git --version # 'git version 2.31.1'
 > git ls-remote --symref -- https://gitlab.com/study-sg/vector-role.git # timeout=10
 > git rev-parse --resolve-git-dir /var/lib/jenkins/caches/git-a48af1737c0a2d91d45969438b8e5585/.git # timeout=10
Setting origin to https://gitlab.com/study-sg/vector-role.git
 > git config remote.origin.url https://gitlab.com/study-sg/vector-role.git # timeout=10
Fetching & pruning origin...
Listing remote references...
 > git config --get remote.origin.url # timeout=10
 > git --version # timeout=10
 > git --version # 'git version 2.31.1'
 > git ls-remote -h -- https://gitlab.com/study-sg/vector-role.git # timeout=10
Fetching upstream changes from origin
 > git config --get remote.origin.url # timeout=10
 > git fetch --tags --force --progress --prune -- origin +refs/heads/*:refs/remotes/origin/* # timeout=10
Checking branches...
  Checking branch main
      ‘Jenkinsfile’ found
    Met criteria
Changes detected: main (8bc50a5d795a511cfa2001d2c3436d9d4bb0784f → 9c63bd74e145deb155964827d24df616e34d5ccc)
Scheduled build for branch: main
Processed 1 branches
[Mon Feb 13 23:13:41 UTC 2023] Finished branch indexing. Indexing took 6.9 sec
Finished: SUCCESS
```
</details>
<details>
    <summary>Multibranch pipeline status</summary>
    <img src="assets/scr3.png"
     alt="git source repository"
     style="float: left; margin-right: 10px;" />
</details>

---

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True), по умолчанию параметр 
имеет значение False и запускает прогон с флагами `--check --diff`.

#### Ответ

<details>
<summary>Скрипт pipeline</summary>

```groovy
node("ansible"){
    // pull repository
    stage("Git checkout"){
        git branch: 'main', credentialsId: '275e54ea-f7a0-4cc4-8c32-57b0b09fb6f3', url: 'git@gitlab.com:study-sg/playbook-example.git'
    }
    // install requirement roles
    stage("Install requirements"){
        sh 'ansible-galaxy install -r requirements.yml -p roles/'
    }
    // start playbook
    stage("Run playbook"){
        // check boolean parameter 'run_prod'
        if (params.run_prod){
            sh 'ansible-playbook site.yml -i inventory/prod.yml --user=root --extra-vars "ansible_sudo_pass=PUT_YOUR_SUDO_PASS_HERE"'
        }
        else{
            sh 'ansible-playbook site.yml -i inventory/prod.yml --diff --check --user=root --extra-vars "ansible_sudo_pass=PUT_YOUR_SUDO_PASS_HERE"'
        }
    }
}

```

</details>

<details>
<summary>Лог pipeline</summary>

```
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on clt-01 in /opt/jenkins_agent/workspace/Scripted pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Git checkout)
[Pipeline] git
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential 275e54ea-f7a0-4cc4-8c32-57b0b09fb6f3
Fetching changes from the remote Git repository
 > git rev-parse --resolve-git-dir /opt/jenkins_agent/workspace/Scripted pipeline/.git # timeout=10
 > git config remote.origin.url git@gitlab.com:study-sg/playbook-example.git # timeout=10
Fetching upstream changes from git@gitlab.com:study-sg/playbook-example.git
 > git --version # timeout=10
 > git --version # 'git version 2.31.1'
using GIT_SSH to set credentials 
[INFO] Currently running in a labeled security context
[INFO] Currently SELinux is 'enforcing' on the host
 > /usr/bin/chcon --type=ssh_home_t /opt/jenkins_agent/workspace/Scripted pipeline@tmp/jenkins-gitclient-ssh12740453260811342391.key
Verifying host key using known hosts file, will automatically accept unseen keys
 > git fetch --tags --force --progress -- git@gitlab.com:study-sg/playbook-example.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Checking out Revision 76112335580829437360f796ed4c6d88fd099a51 (refs/remotes/origin/main)
Commit message: "inventory"
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 76112335580829437360f796ed4c6d88fd099a51 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D main # timeout=10
 > git checkout -b main 76112335580829437360f796ed4c6d88fd099a51 # timeout=10
 > git rev-list --no-walk 76112335580829437360f796ed4c6d88fd099a51 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Install requirements)
[Pipeline] sh
+ ansible-galaxy install -r requirements.yml -p roles/
Starting galaxy role install process
- vector (1.4.1) is already installed, skipping.
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Run playbook)
[Pipeline] sh
+ ansible-playbook site.yml -i inventory/prod.yml --user=root --extra-vars ansible_sudo_pass=********

PLAY [Install vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [vector : Vector | Check virttype] ****************************************
ok: [localhost] => {
    "msg": [
        "virtualbox"
    ]
}

TASK [vector : Vector | Install package Debian/Ubuntu] *************************
skipping: [localhost]

TASK [vector : Vector | Install package Fedora] ********************************
ok: [localhost]

TASK [vector : Vector | Generate config] ***************************************
ok: [localhost]

TASK [vector : Vector | Configure service] *************************************
ok: [localhost]

TASK [vector : Flush handlers] *************************************************

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   

[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

</details>

---

7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

#### Ответ

[Declarative pipeline](https://gitlab.com/study-sg/vector-role/-/blob/main/Jenkinsfile)\
[Scripted pipeline](https://gitlab.com/study-sg/playbook-example/-/blob/main/ScriptedJenkinsfile)

---

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, которые завершились хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением с названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline таким образом, чтобы он мог сначала запустить через Ya.Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать 
плейбук. Тем самым, мы должны по нажатию кнопки получить готовую к использованию систему.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
