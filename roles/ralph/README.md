Ansible role: Ralph
===================
Ansible role to install Ralph

Requirements
-------------
Python 3.9.15

Role Variables
--------------

Here is the list of all variables:

- `ralph_user: "admin"`
- `ralph_packages:` List of packages that can be installed


Example Playbook
----------------

.. code:: yaml

    - hosts: servers
      roles:
         - role: ralph
           become_user: admin
           become: true