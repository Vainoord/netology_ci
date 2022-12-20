Role Name
=========

Simple lighthouse with nginx web-server deploy role.

Requirements
------------

This role has tested on:

- Centos 7

Required packages:

- git

Role Variables
--------------

| Variable | Description | Default value | Location |
|------|------------|---|---|
|nginx_default_port|default nginx http port|`8009`|[defaults folder](defaults/main.yml)|
|lighthouse_port|default lighthouse http port|`9000`|[defaults folder](defaults/main.yml)|
|nginx_user_name|user for access and modify folders and files related to lighthouse|`nginx`|[vars folder](vars/main.yml)|
|lighthouse_vcs|lighthouse source|`https://github.com/VKCOM/lighthouse.git`|[vars folder](vars/main.yml)|
|lighthouse_dir|folder for lighthouse location|`/usr/share/lighthouse`|[vars folder](vars/main.yml)|

Dependencies
------------

This role has no required dependencies.

Example Playbook
----------------

    - name: Install nginx
      hosts: lighthouse
      handlers:
      pre_tasks:
        - name: Lighthouse | Install dependencies (git)
          become: true
          ansible.builtin.yum:
            name: git
            state: present
          tags:
            - install_git
      roles:
        - lighthouse

License
-------

MIT

Author Information
------------------

[Lighthouse](https://github.com/VKCOM/lighthouse) source.

Role created by Stanislav Gurniak\
https://github.com/vainoord\
https://gitlab.com/vainoord
