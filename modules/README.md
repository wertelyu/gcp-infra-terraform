# Understanding Terraform Module Structure

## Every module has:

- **main.tf**: Resources
- **variables.tf**: Input variables
- **outputs.tf**: Output values (used by other modules)
- **versions.tf**: Provider versions (optional, we auto-generate)
