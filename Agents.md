# GitHub Copilot Instructions

## Project Overview

This repository manages infrastructure for Business Central Admin Center environments using Terraform with the published `bcadmincenter` provider.

## Code Standards

- **Terraform Version**: Use version `1.14.7` as specified in [src/providers.tf](src/providers.tf)
- **Formatting**: Always run `terraform fmt` before committing
- **Providers**: 
  - AzureRM `4.64.0` for Azure resources
   - `bcadmincenter` provider `0.1.5` from Terraform Registry (`axiansinfoma/bcadmincenter`)

## Commit Conventions

**Always** follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `chore:` for maintenance tasks
- `refactor:` for code refactoring

## Provider Specifics

### bcadmincenter Provider

- Source: Terraform Registry (`axiansinfoma/bcadmincenter`)
- Resources available:
  - `bcadmincenter_environment` - BC environment management
  - `bcadmincenter_environment_settings` - BC environment configuration
- Provider requires Azure tenant ID for authentication

### Azure Resources

- Backend state stored in Azure Storage Account (configured via secrets)
- Uses OIDC authentication with Azure AD
- Resource naming follows pattern: `<type>-demo-prd-<component>`

## Workflow Guidelines

1. **Branch Strategy**: 
   - Main branch: `main` (protected)
   - Feature branches for development

2. **Pull Requests**:
   - Terraform plan runs automatically on PRs
   - Plan output posted as PR comment
   - Apply runs only on merge to `main` when changes detected

3. **Required Secrets** (configured in GitHub environment `production`):
   - `ARM_CLIENT_ID` - Azure service principal client ID
   - `ARM_SUBSCRIPTION_ID` - Azure subscription ID
   - `ARM_TENANT_ID` - Azure tenant ID
   - `BACKEND_RESOURCE_GROUP_NAME` - Backend storage resource group
   - `BACKEND_STORAGE_ACCOUNT_NAME` - Backend storage account
   - `BACKEND_CONTAINER_NAME` - Backend storage container
   - `BACKEND_KEY` - Terraform state file key

## File Organization

- `src/providers.tf` - Provider configurations and versions
- `src/vars.tf` - Variable declarations
- `src/environment.tf` - BC environment resources
- Run Terraform commands from the `src/` directory

## Best Practices

- Never hardcode sensitive values
- Use variables for configurable values
- Keep resources logically grouped in separate files
- Document resource dependencies using Terraform references
- Test changes with `terraform plan` before applying

## Summary Documents

**Never** create summary documents unless explicitly asked.