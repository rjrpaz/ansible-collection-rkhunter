# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-19

### Added
- Initial rkhunter collection structure
- rkhunter role for managing rootkit hunter status checks and database updates
- Support for checking rkhunter status with detailed output
- Support for updating rkhunter database when drifts are detected
- CI/CD pipeline with GitHub Actions
- Docker development environment
- Comprehensive documentation and usage examples
- Example playbooks for common operations

### Features
- Check rkhunter status across multiple hosts
- Update rkhunter database selectively based on status
- Secure command execution with proper error handling
- Support for RHEL/CentOS, Ubuntu, and Debian distributions

[1.0.0]: https://github.com/rjrpaz/ansible-collection-rkhunter/releases/tag/v1.0.0