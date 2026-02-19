# GitHub Actions Workflows

This collection uses centralized workflows from the [ansible-collection-template](https://github.com/rjrpaz/ansible-collection-template) repository.

## Workflow Architecture

Instead of copying workflows to each collection repository, we reference the workflows directly from the template repository. This approach provides several benefits:

- **Centralized Maintenance**: All workflow updates are made in one place
- **Consistency**: All collections use the same CI/CD processes
- **Easy Updates**: Changes to workflows automatically apply to all collections
- **Reduced Duplication**: No need to copy/paste workflow files

## Available Workflows

### 1. CI/CD Pipeline (`ci.yml`)

**Trigger**: Push, Pull Request, Manual dispatch
**Purpose**: Complete CI/CD pipeline including linting, testing, and publishing

```yaml
jobs:
  call-ci-workflow:
    uses: rjrpaz/ansible-collection-template/.github/workflows/ci.yml@split-workflows
    secrets: inherit
```

**Features**:
- Runs ansible-lint on the collection
- Tests against multiple Ansible versions (5.x, 6.x, 7.x)
- Tests against multiple Python versions (3.9, 3.10, 3.11)
- Builds and validates the collection
- Publishes to Ansible Galaxy on main branch pushes

### 2. Lint Only (`lint.yml`)

**Trigger**: Manual dispatch
**Purpose**: Run only linting checks

```yaml
jobs:
  lint:
    uses: rjrpaz/ansible-collection-template/.github/workflows/lint-only.yml@split-workflows
```

### 3. Test Only (`test.yml`)

**Trigger**: Manual dispatch
**Purpose**: Run only test suite

```yaml
jobs:
  test:
    uses: rjrpaz/ansible-collection-template/.github/workflows/test-only.yml@split-workflows
```

### 4. Release (`release.yml`)

**Trigger**: Release published, Manual dispatch
**Purpose**: Handle release-specific workflows

```yaml
jobs:
  release:
    uses: rjrpaz/ansible-collection-template/.github/workflows/release.yml@split-workflows
    secrets: inherit
```

## Workflow Inheritance

The workflows inherit:
- **Secrets**: All repository secrets are passed through using `secrets: inherit`
- **Environment Variables**: Standard GitHub environment variables
- **Repository Context**: The calling repository's context is available

## Required Secrets

For full functionality, ensure these secrets are configured in your repository:

- `GALAXY_API_KEY`: Required for publishing to Ansible Galaxy

## Customization

If you need collection-specific workflow behavior:

1. **Override specific jobs**: Reference the template workflow but override specific jobs
2. **Add additional jobs**: Include extra jobs alongside the template workflow call
3. **Fork the template**: Create a collection-specific copy if major customization is needed

### Example: Adding Custom Jobs

```yaml
---
name: 'CI/CD with Custom Steps'

on:
  push:
  pull_request:

jobs:
  call-ci-workflow:
    uses: rjrpaz/ansible-collection-template/.github/workflows/ci.yml@split-workflows
    secrets: inherit

  custom-security-scan:
    name: 'Security Scan'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: 'Run security scan'
        run: |
          # Custom security scanning steps
```

## Template Repository Updates

When the template repository workflows are updated:
- Changes automatically apply to all collections using those workflows
- No manual updates needed in individual collection repositories
- Test the changes in the template repository before merging

## Troubleshooting

### Workflow Not Found
If you get a "workflow not found" error, ensure:
- The workflow exists in the template repository
- The path and filename are correct
- The branch reference (`@split-workflows`) is correct

### Permission Issues
If workflows fail with permission errors:
- Check that `secrets: inherit` is included for workflows that need secrets
- Verify required secrets are configured in the repository settings

### Version Pinning
For production use, consider pinning to specific versions instead of `@split-workflows`:

```yaml
uses: rjrpaz/ansible-collection-template/.github/workflows/ci.yml@v1.0.0
```

**Note**: Currently using `@split-workflows` branch for testing. Once tested and stable, these references should be updated to `@main`.