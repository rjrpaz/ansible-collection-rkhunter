# Usage Guide

This guide provides comprehensive usage examples for the `rjrpaz.rkhunter` collection.

## Installation

Install the collection from Ansible Galaxy:

```bash
ansible-galaxy collection install rjrpaz.rkhunter
```

## Basic Usage

### Check rkhunter status

Check the rkhunter status on all servers in your inventory:

```bash
ansible-playbook -u username -i inventory playbooks/update_rkhunter.yml
```

### Check rkhunter status on specific server

```bash
ansible-playbook -u username -i inventory playbooks/update_rkhunter.yml --limit 'server.example.com'
```

### Update rkhunter database

Update the rkhunter database when you have expected changes (like after system updates):

```bash
ansible-playbook -u username -i inventory playbooks/update_rkhunter.yml -e "update=yes" --limit 'server.example.com'
```

or using the dedicated variable:

```bash
ansible-playbook -u username -i inventory playbooks/update_rkhunter.yml -e "rkhunter_update_status=yes" --limit 'server.example.com'
```

## Advanced Usage

### Custom Playbook

Create your own playbook with the rkhunter role:

```yaml
---
- name: Custom rkhunter management
  hosts: webservers
  become: true
  vars:
    rkhunter_update_status: "no"

  tasks:
    - name: Check rkhunter status
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      tags: check

    - name: Update database if needed
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      vars:
        rkhunter_update_status: "yes"
      tags: update
      when: rkhunter_update_needed | default(false)
```

### Using the legacy 'update' variable

For backwards compatibility, you can also use the `update` variable:

```yaml
---
- name: Custom rkhunter management (legacy)
  hosts: webservers
  become: true
  vars:
    update: false

  tasks:
    - name: Check rkhunter status
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      tags: check

    - name: Update database if needed
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      vars:
        update: true
      tags: update
      when: rkhunter_update_needed | default(false)
```

### Integration with other roles

```yaml
---
- name: System security management
  hosts: all
  become: true

  tasks:
    - name: Update system packages
      ansible.builtin.package:
        name: "*"
        state: latest
      notify: update rkhunter

    - name: Check rkhunter status
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter

  handlers:
    - name: update rkhunter
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      vars:
        update: true
```

## Understanding the Output

The role will:

1. Check rkhunter status using the standard rkhunter scan command
2. Display any warnings or issues found
3. Optionally update the rkhunter database if `update: true` is set
4. Re-run the status check after updates to verify the changes

### Expected Behaviors

- **Return code 0**: No warnings or issues found
- **Return code 1**: Warnings found (displayed in output)
- **Update mode**: Runs `rkhunter --propupd` to update the file properties database

## Troubleshooting

### rkhunter not found

Ensure rkhunter is installed on target hosts:

```bash
# RHEL/CentOS/Rocky
sudo dnf install rkhunter

# Ubuntu/Debian
sudo apt install rkhunter
```

### Permission denied

Ensure you're running with sufficient privileges:

```bash
ansible-playbook -b -K your-playbook.yml
```

### False positives

If you get warnings for expected changes, update the rkhunter database:

```bash
ansible-playbook -i inventory playbooks/update_rkhunter.yml -e "update=yes"
```