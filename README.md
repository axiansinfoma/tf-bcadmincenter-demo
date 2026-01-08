# Business Central Admin Center Terraform Demo

This repository demonstrates infrastructure management for Microsoft Dynamics 365 Business Central environments using Terraform with a custom provider for the Business Central Admin Center API.

## Architecture

The repository uses:
- **Terraform** `1.14.3` for infrastructure as code
- **Custom bcadmincenter provider** `0.0.1` for Business Central environment management
- **Azure provider** `4.48.0` for Azure infrastructure
- **GitHub Actions** for CI/CD automation
- **Azure Storage** for Terraform state backend
- **OIDC authentication** for secure Azure access

## Prerequisites

- Terraform `1.14.3`
- Azure subscription with appropriate permissions
- Azure AD tenant with Business Central Admin Center access
- GitHub repository with configured secrets and environment

## Repository Structure

```
.
├── bin/
│   └── terraform-provider-bcadmincenter    # Custom provider binary
├── .github/
│   └── workflows/
│       └── terraform.yml                    # CI/CD pipeline
├── application_insights.tf                  # Azure monitoring resources
├── environment.tf                           # BC environment configuration
├── providers.tf                             # Provider configuration
└── vars.tf                                  # Variable declarations
```

## Using Terraform

### Local Development

1. **Initialize Terraform**
   ```bash
   terraform init \
     -backend-config="resource_group_name=<rg-name>" \
     -backend-config="storage_account_name=<storage-name>" \
     -backend-config="container_name=<container-name>" \
     -backend-config="key=<state-key>" \
     -backend-config="use_azuread_auth=true"
   ```

2. **Install Custom Provider**
   
   The `bcadmincenter` provider binary must be installed locally:
   ```bash
   # Create plugin directory
   PLUGIN_DIR="${HOME}/.terraform.d/plugins/registry.terraform.io/vllni/bcadmincenter/0.0.1/linux_amd64"
   mkdir -p "${PLUGIN_DIR}"
   
   # Copy provider binary
   cp bin/terraform-provider-bcadmincenter "${PLUGIN_DIR}/"
   chmod +x "${PLUGIN_DIR}/terraform-provider-bcadmincenter"
   
   # Create CLI configuration
   cat > "${HOME}/.terraformrc" <<EOF
   provider_installation {
     filesystem_mirror {
       path    = "${HOME}/.terraform.d/plugins"
       include = ["registry.terraform.io/vllni/bcadmincenter"]
     }
     direct {
       exclude = ["registry.terraform.io/vllni/bcadmincenter"]
     }
   }
   EOF
   ```

3. **Validate Configuration**
   ```bash
   terraform validate
   ```

4. **Format Code**
   ```bash
   terraform fmt
   ```

5. **Plan Changes**
   ```bash
   terraform plan
   ```

6. **Apply Changes**
   ```bash
   terraform apply
   ```

### Common Commands

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize working directory |
| `terraform validate` | Validate configuration syntax |
| `terraform fmt` | Format configuration files |
| `terraform plan` | Preview infrastructure changes |
| `terraform apply` | Apply infrastructure changes |
| `terraform destroy` | Destroy managed infrastructure |
| `terraform output` | Display output values |
| `terraform state list` | List resources in state |

## CI/CD Pipeline

The repository uses GitHub Actions for automated Terraform workflows.

### Pipeline Workflow

1. **On Pull Request**:
   - Checks out code
   - Installs custom bcadmincenter provider
   - Initializes Terraform with remote backend
   - Validates formatting (`terraform fmt -check`)
   - Generates execution plan (`terraform plan`)
   - Posts plan output as PR comment
   - Uploads plan artifact

2. **On Merge to Main**:
   - Runs plan validation
   - If changes detected (exit code 2):
     - Downloads plan artifact
     - Applies changes automatically (`terraform apply -auto-approve`)

### Workflow Triggers

- **Push to `main`**: Full plan and apply
- **Pull Request to `main`**: Plan only with PR comment

### Pipeline Features

- Automatic Terraform version detection from [providers.tf](providers.tf)
- Custom provider installation from repository binary
- Azure authentication via OIDC (no stored credentials)
- Plan output published to PR comments and job summaries
- Conditional apply only when infrastructure changes exist

## GitHub Environment Configuration

### Environment: `production`

The pipeline uses a GitHub environment named `production` for deployment protection and secret management.

**Required Secrets**:

| Secret Name | Description |
|-------------|-------------|
| `AZURE_CLIENT_ID` | Azure AD service principal application ID |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID |
| `AZURE_TENANT_ID` | Azure AD tenant ID |
| `BACKEND_RESOURCE_GROUP_NAME` | Resource group containing state storage |
| `BACKEND_STORAGE_ACCOUNT_NAME` | Storage account for Terraform state |
| `BACKEND_CONTAINER_NAME` | Blob container for state files |
| `BACKEND_KEY` | State file name/key |

### Setting Up Secrets

Navigate to: **Repository Settings** → **Environments** → **production** → **Environment secrets**

Configure each secret listed above with appropriate values from your Azure environment.

## Authentication

### Azure OIDC Authentication

The workflow uses OpenID Connect (OIDC) for secure authentication:

- No stored service principal secrets
- Short-lived tokens issued by GitHub
- Requires federated identity credential in Azure AD
- Environment variables set automatically:
  - `ARM_CLIENT_ID`
  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID`
  - `ARM_USE_OIDC=true`

### Business Central Authentication

The `bcadmincenter` provider authenticates using the Azure tenant ID from the current Azure client configuration.

## Backend Configuration

Terraform state is stored remotely in Azure Storage:

- **Backend Type**: `azurerm`
- **Authentication**: Azure AD (OIDC)
- **State Locking**: Enabled via Azure Storage lease
- **Encryption**: Enabled by default on Azure Storage

Configuration is provided via:
- GitHub secrets (CI/CD)
- Command-line arguments (local development)

## Contributing

1. Create a feature branch
2. Make changes following Terraform best practices
3. Run `terraform fmt` to format code
4. Commit using [Conventional Commits](https://www.conventionalcommits.org/)
5. Open a pull request
6. Review Terraform plan in PR comments
7. Merge to `main` to apply changes

## License

This is a demonstration repository. Adjust licensing as needed for your organization.
