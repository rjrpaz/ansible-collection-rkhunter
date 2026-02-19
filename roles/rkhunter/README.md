# Ansible Role: rkhunter

This role manages rkhunter (Rootkit Hunter) status checks and database updates.

## Requirements

- rkhunter package must be installed on target hosts
- Root privileges (role uses `become: true`)

## Role Variables

Available variables are listed below:

```yaml
# Control whether to update the rkhunter database
# Default: false (only check status)
update: false
```

## Dependencies

None.

## Example Playbook

```yaml
---
- name: Check rkhunter status
  hosts: servers
  become: true
  tasks:
    - name: Get rkhunter status
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter

    - name: Update rkhunter database if needed
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      vars:
        update: true
```

## License

MIT

## Author Information

This role was created as part of the rjrpaz.rkhunter collection.