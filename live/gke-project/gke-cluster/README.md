# Understanding Dependencies:

- dependency "network": References ../network module
- config_path: Path to the dependency
- dependency.network.outputs.X: Access outputs from network module
- mock_outputs: Fake values for validation without deploying

## Terragrunt ensures network is created BEFORE cluster

What we deliberately left insecure:

Feature Status Attack Surface
Workload Identity ❌ Disabled Pods access node SA via metadata
Private nodes ❌ Public IPs Nodes exposed to internet
Network policies ❌ Disabled No pod traffic restrictions
Legacy metadata ❌ EnabledEasy token theft (169.254.169.254)
OAuth scopes ❌ cloud-platform Nodes have broad permissions
Master auth networks ❌ Open API accessible from anywhere

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
