# Playbook description

This playbook contains three roles with installation of a listed services:

- Clickhouse
- Vector
- Lighthouse

## GROUP VARS

___

### All

| variable | description |
|:---|:---|
| _ssh_port_ | ssh port on remote hosts |
| _ssh_pkey_file_ | path to ssh privatekey file |
| _sudo_user_ | server user which used for ssh connections |
| _sudo_pass_ | password of server user |

___
