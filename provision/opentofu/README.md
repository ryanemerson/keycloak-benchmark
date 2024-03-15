# OpenTofu
This is the root directory for managing all OpenTofu state.

## Initialization
To create the local state files execute the following commands in this directory:

1. `tofu init`

## Centralized State
The root OpenTofu file defines a remote [S3 backend](https://opentofu.org/docs/language/settings/backends/s3/), to ensure
that all .state files are persisted to an S3 bucket. This allows for state to be shared amongst team members, as well as
enabling our scheduler to remove no longer required resources.

To pull remote state to your local machine, execute:

- `tofu state pull`

## Workspaces
To isolate state created by different team members, [OpenTofu Workspaces](https://opentofu.org/docs/cli/workspaces/)
should be used where appropriate. For example, if user specific ROSA clusters are required a dedicated workspace should
be created for the cluster and any resources deployed to it.

Workspace CRUD:

- `tofu workspace list`
- `tofu workspace new/delete/select <workspace-name>`

When an existing workspace is selected, you must then execute `tofu state pull` to ensure that you have the latest state
on your local machine.
