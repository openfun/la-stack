# Debian Common

Roles for configuring clean Debian / Ubuntu machine

## Supported Platforms

- Debian
  - 10 (buster)
  - 9  (stretch)

- Ubuntu
  - 18.04 (bionic)
  - 16.04 (xenial)

## How to use this role

### Create a playbook
Create a playbook file and in the roles section set the group of tasks that
you need to run. As an example you can use the one below:

```yaml
# playbook.yml
- hosts: all
  remote_user: root
  vars:
    debian_common_admin_user_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc1E ADMIN_USER_1
      - ssh-rsa AAAAB3Nzac2Yc2e ADMIN_USER_2
    debian_common_regular_user_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc1E regular_USER_1
      - ssh-rsa AAAAB3Nzac2Yc2e regular_USER_2
  roles:
    - role: debian-common
      prebootstrap: yes
    - role: debian-common
      bootstrap: yes
      add_remove_keys: yes
      vars:
        debian_common_regular_user: fun_usr
        ports: ["22", "3000"]
```


## The following groups of tasks are available:

### Prebootstrap (prebootstrap)
This tag contains basic setup tasks, such as:
- Add administrator user
    - Default is `admin` in Debian, `ubuntu` in Ubuntu. You can define the variable `{{ debian_common_admin_user }}`
- Update packages cache
- Install sudo package
- Use sudo without a password for the sudo group
- Set up authorized SSH keys for administrator users
    - You need to define `{{ debian_common_admin_user_authorized_keys }}`

### Bootstrap (bootstrap)
This tag contains more advance setup tasks, such as:

- Disallow password authentication for SSH sessions
- Disallow SSH access for root user
- Set hostname
    - You can define `{{ hostname }}`
- Set time zone
    - You can define `{{ debian_common_ntp_timezone }}`
- Enable NTP using systemd-timesyncd
- Make sure to store journald data persistently
- Upgrade all packages
- Install basic packages
    - e.g.: vim, tmux, htop, atop, tree, ufw, emacs, git, curl
- Install supplementary packages - not just debian_common_extra_packages
- Enable firewall using UFW
    - Open general ports (e.g. SSH port, HTTP port; by default SSH)
        - You can define `{{ ports }}`
    - Open specific ports for specific IPs
        - You can define `{{ port_ips }}`
    - You can disable UFW with `debian_common_firewall: no`
- Set and update environment variables
    - You need to define `{{ debian_common_environment_variables }}`
- Create Unix user and group for regularer user
    - You need to define the var `{{ debian_common_regular_user }}`
      (e.g. regularer)
    - Optionally define the var `{{ debian_common_regular_user_group }}`
      (e.g. regularer) otherwise, it will be the same as
      `{{ debian_common_regular_user }}`
- Create application regular directory
- Add SSH keys for GitHub's «regular keys»
- Set up authorized SSH keys for the regularer user
    - You need to define `{{ debian_common_regular_user_authorized_keys }}`
- Ensure github.com is a known host
    - You need to define `{{ debian_common_regular_user }}`
    - This variable adds by default GitHub as a known host, but it's possible
      to change it overwriting `{{ debian_common_known_hosts }}`
- Set global bash history configuration to the format bellow:
    `285  Thu 08 Aug 2019 01:43:40 PM UTC some comand`
    See bellow for available variables.

#### Set hostname (set-hostname)
- Set hostname to host-specific variable
    - You need to define `{{ hostname }}`

#### Set bash history configuration:
- Enable/disable the history configuration
  `debian_common_bash_history: true`
    
- Under `debian_common_bash_history_config:`
  - Set the amount of lines to keep in the history buffer
    `histsize: '5000'`
  - Set the amount of lines to keep in the history file
    `histfilesize: '3000'`
  - Set the time format to append before each history command (see
    `man history` for complete options)
    `histtimeformat: '%c%t'`


### Update authorized SSH keys (add-remove-keys)
- Updates SSH authorized keys:

    - You need to define the following list of variables containing the SSH
      public-keys for both the administrator and the regular users respectively:

```
{{ debian_common_admin_user_authorized_keys }}
{{ debian_common_regular_user_authorized_keys }}
```