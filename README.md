Terraform module which creates spot instance with attached data drive.
Data drive snapshot will be created automatically on a daily basis.
Recent 5 snapshots will be stored.

To deploy, run these commands in sequence:
1. Init submodules: `terraform init`
2. Check what actions will be done: `terraform plan`
3. Apply with `terraform apply`
