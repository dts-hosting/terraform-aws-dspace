# DSpace services

Configuration in this directory creates DSpace services.

*Note: this example is used for internal testing and is not
intended for general use other than as a reference.*

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
