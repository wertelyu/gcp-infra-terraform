## Configuration Hierarchy

```bash
┌─────────────────────────────────────────┐
│ root.hcl                                │
│ - provider with impersonation           │
│ - terraform_sa                          │
│ - default region/zone                   │
└─────────────────┬───────────────────────┘
                  │
                  ↓
┌─────────────────────────────────────────┐
│ live/env.hcl                            │
│ - environment = "dev"                   │
│ - state_bucket = "tfstate-...-dev"      │
│ - name_prefix = "dev"                   │
│ - inherits region/zone from root        │
└─────────────────┬───────────────────────┘
                  │
        ┌─────────┴─────────┐
        ↓                   ↓
┌───────────────────┐ ┌───────────────────┐
│ project.hcl (GKE) │ │ project.hcl (DB)  │
│ - project_id      │ │ - project_id      │
│ - GKE defaults    │ │ - DB defaults     │
│ - inherits env    │ │ - inherits env    │
└─────────┬─────────┘ └─────────┬─────────┘
          │                     │
          ↓                     ↓
   ┌─────────────┐       ┌─────────────┐
   │ terragrunt  │       │ terragrunt  │
   │ .hcl        │       │ .hcl        │
   └─────────────┘       └─────────────┘
```
