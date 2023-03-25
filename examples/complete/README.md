# Complete DSpace example

Configuration in this directory creates a full DSpace deployment. The only
additional thing required is a DNS record that points to the load balancer.

## Usage

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example create resources which cost money. Run terraform destroy
when you don't need these resources.
