Ansible role: Pyenv
===================
Ansible role to install pyenv and python versions.

Role Variables
--------------

Here is the list of all variables and their default values:

- `pyenv_env: "user"` (should be either `"user"` or `"system"`)
- `pyenv_path: "{% if pyenv_env == 'user' %}{{ ansible_env.HOME }}/pyenv{% else %}/usr/local/pyenv{% endif %}"`
- `pyenv_owner: "admin"`
- `pyenv_owner_group: "admin"`
- `pyenv_python_versions: [3.9.15]`
- `pyenv_virtualenvs: [{ venv_name: latest, py_version: 3.9.15 }]`
- `pyenv_global: [3.9.15]`
- `pyenv_update_git_install: true` (get latest pyenv from git)
- `pyenv_enable_autocompletion: false`
- `pyenv_setting_path: "{% if pyenv_env == 'user' %}~/.bashrc{% else %}/etc/profile.d/pyenv.sh{% endif %}"`


Example Playbook
----------------

.. code:: yaml

    - hosts: servers
      roles:
         - role: pyenv
           pyenv_path: "{{ home }}/pyenv"
           pyenv_owner: "{{ instance_owner }}"
           pyenv_global:
             - 3.9.15
             - 3.7.0
           pyenv_enable_autocompletion: false
           pyenv_python_versions:
             - 3.9.15
           pyenv_virtualenvs:
             - venv_name: latest_v39
               py_version: 3.9.15

