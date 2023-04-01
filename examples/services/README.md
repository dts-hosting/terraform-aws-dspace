# DSpace services

Configuration in this directory creates DSpace services.

## Usage

To run this example you need to create `terraform.tfvars`:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update the values as appropriate:

```bash
backend_img              = "dspace/dspace:dspace-7_x"
cluster_name             = "dspace-cluster"
db_host                  = "database.dspace.org"
db_name                  = "dspace"
db_password_param        = "dspace-db-password"
db_username_param        = "dspace-db-username"
efs_name                 = "dspace-efs"
domain                   = "dspace.org"
frontend_img             = "dspace/dspace-angular:dspace-7_x-dist"
lb_name                  = "dspace-lb"
log_group_name           = "/aws/ecs/dspace"
profile                  = "default"
profile_for_dns          = "default"
security_group_name      = "dspace-private-app"
solr_discovery_namespace = "dspace.solr"
solr_img                 = "dspace/dspace-solr:dspace-7_x"
subnet_type              = "Private"
vpc_name                 = "dspace-vpc"
```

The key ones are:

- `cluster_name`
  - the name of an existing ECS cluster
- `db_*`
  - valid db parameters, including existing SSM param names
- `domain`
  - this is the domain to use for public DNS
  - you must have a Route53 hosted zone available for this domain
- `efs_name`
  - the name of an existing EFS
- `lb_name`
  - the name of an existing ALB
- `log_group_name`
  - the name of an existing CloudWatch log group
- `profile_for_dns`
  - set to a different profile if necessary
  - this profile should contain the hosted zone for `domain`
- `security_group_name`
  - the name of an existing security group
- `solr_discovery_namespace`
  - the name of an existing service discovery namespace for Solr
- `subnet_type`
  - the type (by tag) of existing subnets
- `vpc_name`
  - the name of an existing vpc

Then execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example creates resources which cost money. Run terraform destroy
when you don't need these resources.
