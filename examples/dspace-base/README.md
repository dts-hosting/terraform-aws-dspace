# DSpace base resources

Configuration in this directory creates base resources required to
deploy DSpace.

- VPC, subnets, security groups etc.
- ALB (application load balancer)
- RDS Postgres Serverless
- EFS (storage) & EC2 bastion for mount point

## Usage

To run this example you need to execute:

```bash
export AWS_PROFILE=$profile # optional, if wanting to set the profile to use
terraform init
terraform plan
terraform apply
```
