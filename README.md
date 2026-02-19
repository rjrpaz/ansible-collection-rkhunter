# Ansible Collection - rjrpaz.rkhunter

Ansible collection for managing rkhunter (Rootkit Hunter) configuration, status checks, and database updates.

## Included content

### Roles

- **rkhunter**: Manages rkhunter status checks and database updates

## Installing this collection

You can install the rjrpaz.rkhunter collection with the Ansible Galaxy CLI:

```bash
ansible-galaxy collection install rjrpaz.rkhunter
```

## Using this collection

### Basic Usage

Use the fully qualified collection name (FQCN) as recommended:

```yaml
---
- name: Check rkhunter status
  hosts: all
  become: true
  tasks:
    - name: Include rkhunter role
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      vars:
        update: false
```

### Example Playbooks

#### Check rkhunter status (default)

```yaml
---
- name: Check rkhunter status on all servers
  hosts: all
  become: true
  tasks:
    - name: Get rkhunter status
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
```

#### Update rkhunter database

```yaml
---
- name: Update rkhunter database
  hosts: all
  become: true
  tasks:
    - name: Update rkhunter status database
      ansible.builtin.include_role:
        name: rjrpaz.rkhunter.rkhunter
      vars:
        update: true
```

## Requirements

- Ansible 5.0+ or ansible-core 2.15+
- Supported platforms: RHEL/CentOS/Rocky Linux 8+, Ubuntu 20.04+, Debian 11+
- rkhunter package must be installed on target hosts

## Role Variables

Available variables are listed below, along with default values:

```yaml
# Control whether to update the rkhunter database
# Default: false (only check status)
update: false
```

## Supported Platforms

This collection is tested and supported on:

- **Operating Systems**: RHEL/CentOS/Rocky Linux 8+, Ubuntu 20.04+, Debian 11+
- **Architectures**: x86_64, ARM64

## Prerequisites

### System Requirements

Ensure your target hosts meet these requirements:
- Supported operating system (see above)
- SSH access with sudo privileges
- Python 3.6 or later
- rkhunter package installed and configured

## Usage Examples

### Check rkhunter status from all servers in inventory

```bash
ansible-playbook -u username -i inventory playbooks/update_rkhunter.yml
```

### Check rkhunter status from specific server

```bash
ansible-playbook -u username -i inventory playbooks/update_rkhunter.yml --limit 'server.example.com'
```

### Update rkhunter database on specific server (if there is an expected drift)

```bash
ansible-playbook -u username -i inventory playbooks/update_rkhunter.yml -e "update=yes" --limit 'server.example.com'
```

## Development and Testing

### Local Development with Docker

This project includes Docker-based tooling for consistent development environments.

#### Prerequisites to locally develop the collection

- Docker installed and running
- Make utility

#### Available Commands

```bash
# Lint the collection using ansible-lint
make lint

# Build the Docker image for development
make build-image

# Run arbitrary ansible commands in the container
make ansible -- --version

# Clean up generated files
make clean
```

#### Docker Development Environment

The included `Dockerfile` provides a containerized environment with:

- Ubuntu 24.04 base
- Ansible and ansible-lint pre-installed
- Python 3 and pip
- All necessary development tools

To use the development environment:

```bash
# Build the development image
make build-image

# Run linting
make lint

# Interactive development session
docker run --rm -it -v $(PWD):/workdir -w /workdir ansible-toolbox bash
```

### Testing

#### Local Collection Testing

```bash
# Build the collection
ansible-galaxy collection build

# Install locally for testing
ansible-galaxy collection install rjrpaz-rkhunter-*.tar.gz --force

# Run the test playbook
ansible-playbook tests/test.yml
```

#### Continuous Integration

The project includes GitHub Actions workflows that:

- Run `ansible-lint` on all branches
- Test against multiple Ansible versions (5.x, 6.x, 7.x) with compatible Python versions
- Build and validate the collection
- Publish to Galaxy (main branch only)

### Linting

#### Using Docker (Recommended)

```bash
make lint
```

#### Using Local ansible-lint

```bash
# Install ansible-lint
pip install ansible-lint

# Run linting
ansible-lint
```

### Building and Publishing

#### Manual Build

```bash
# Build collection artifact
ansible-galaxy collection build

# Install for testing
ansible-galaxy collection install rjrpaz-rkhunter-*.tar.gz

# Manual publish (requires Galaxy API key)
ansible-galaxy collection publish rjrpaz-rkhunter-*.tar.gz --api-key YOUR_API_KEY
```

#### Automated Publishing

The collection is automatically published to Ansible Galaxy when:

1. Code is pushed to the `main` branch
2. All tests and linting pass
3. `GALAXY_API_KEY` secret is configured in GitHub repository settings

## Troubleshooting

### Common Issues

#### Permission Denied

Ensure the user has sudo privileges:

```bash
ansible-playbook -b -K your-playbook.yml
```

#### Package Installation Failed

Verify the package name is correct for your distribution:

```bash
# RHEL/CentOS/Rocky
dnf search PACKAGE_NAME

# Ubuntu/Debian
apt search PACKAGE_NAME
```

#### Service Failed to Start

Check service status and logs:

```bash
systemctl status SERVICE_NAME
journalctl -u SERVICE_NAME
```

### Debug Mode

Enable Ansible debug output:

```bash
ansible-playbook -vvv your-playbook.yml
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `make lint`
5. Submit a pull request

### Development Workflow

```bash
# Clone your fork
git clone https://github.com/rjrpaz/ansible-collection-rkhunter.git
cd ansible-collection-rkhunter

# Create feature branch
git checkout -b feature/my-improvement

# Make changes and test
make lint
ansible-playbook tests/test.yml --syntax-check

# Commit and push
git commit -m "Add: my improvement"
git push origin feature/my-improvement
```

## License

MIT

## Author Information

Roberto - [https://github.com/rjrpaz](https://github.com/rjrpaz)