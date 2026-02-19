# Ansible Role: rkhunter

This role manages rkhunter (Rootkit Hunter) status checks and database updates.

## Requirements

- rkhunter package must be installed on target hosts
- Root privileges (role uses `become: true`)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Control rkhunter operation mode
# When set to "no" (default): Only check rkhunter status and display results
# When set to "yes": Update rkhunter database after status check if warnings found
rkhunter_update_status: "no"

# Alternative variable name for backwards compatibility
# This variable is used when calling the role with the 'update' parameter
update: false  # Only check status (default)
update: true   # Update database if warnings found
```

### Variable Usage

The role supports two ways to control its behavior:

1. **Using `rkhunter_update_status`** (recommended):
   - `"no"`: Only check rkhunter status and display results
   - `"yes"`: Update rkhunter database if warnings are found

2. **Using `update`** (backwards compatibility):
   - `false`: Only check status
   - `true`: Update database if warnings found

## Dependencies

None.

## Example Playbook

### Check rkhunter status only

```yaml
---
- name: Check rkhunter status
  hosts: servers
  become: true
  tasks:
    - name: Get rkhunter status
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
```

### Update rkhunter database (using update variable)

```yaml
---
- name: Update rkhunter database
  hosts: servers
  become: true
  tasks:
    - name: Update rkhunter database if needed
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      vars:
        update: true
```

### Update rkhunter database (using rkhunter_update_status)

```yaml
---
- name: Update rkhunter database
  hosts: servers
  become: true
  vars:
    rkhunter_update_status: "yes"
  tasks:
    - name: Update rkhunter database if needed
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
```

## License

MIT

## Author Information

This role was created as part of the rjrpaz.rkhunter collection.