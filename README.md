# DSpace Terraform modules

Terraform modules to deploy [DSpace](https://dspace.lyrasis.org/) as
[AWS ECS](https://aws.amazon.com/ecs/) services.

## Requirements

As a group the modules require (but do not create):

- A VPC
- 2+ subnets within the VPC (public & private recommended)
- 1+ security group/s that allow ingress from outside the VPC
- 1+ security group/s that allow ingress from within the VPC
- An application load balancer assigned to public subnets in the VPC
- EFS storage for persistent data permitting access from within the VPC
- ECS cluster / autoscaling group (latter optional if using Fargate)
- Postgres database (RDS or other) connection details
- Solr connection details (or service discovery if using the included module)
- DNS records (Route53 or other) for publicly accessible DSpace services

These resources can be created however you like and are broadly outlined
as implementation details can vary (such as whether to use public vs.
private subnets with a NAT gateway; the specifics of how security groups
are defined, and so on). There are many, many viable ways to do it.

Resources that are "modified" by one or more of the DSpace modules are:

- EFS: access points are created
- Load balancer: listener rules are created

Therefore it is recommended that these resources be considered "dedicated"
to DSpace or that care is taken to ensure that mixed-usage does not lead to
unintended conflicts.

The example projects show different ways that externally created resources
can be used with this module.

## Examples

- [Complete DSpace example generating all resources (except DNS record)](examples/complete)
- [Using pre-existing resources example as inputs to DSpace modules](examples/services)
- [Scripts for interacting with DSpace services](examples/ops)

## Usage

### Solr

The Solr module is completely optional. The DSpace backend requires a Solr
url, and this module provides a way to run Solr as an ECS service with
DSpace Solr configuration included. If you do use this module it requires
[service discovery](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-discovery.html).

```hcl
resource "aws_service_discovery_private_dns_namespace" "this" {
  name = "dspace.solr"
  vpc  = module.vpc.vpc_id
}
```

Module configuration:

```hcl
module "solr" {
  source = "github.com/dts-hosting/terraform-aws-dspace//modules/solr"

  cluster_id           = var.cluster_id # AWS ECS cluster id
  efs_id               = var.efs_id # AWS EFS id
  img                  = var.solr_img # DSpace Solr docker image
  log_group            = "/aws/ecs/dspace" # AWS CloudWatch log group (not created / must exist already)
  name                 = "demo-solr" # Name for resources created by the module (must be unique)
  security_group_id    = var.security_group_id # Security group id (must allow 8983 within VPC)
  service_discovery_id = aws_service_discovery_private_dns_namespace.this.id
  subnets              = var.subnets # Subnet ids (requires route to internet for downloading images)
  vpc_id               = var.vpc_id # VPC id
}
```

Given this example, with service discovery, Solr would be available at:

- `http://demo-solr.dspace.solr:8983/solr`

For all configuration options review the [variables file](modules/solr/variables.tf).

### Backend

Configuration for the DSpace backend (REST API server):

```hcl
module "backend" {
  source = "github.com/dts-hosting/terraform-aws-dspace//modules/backend"

  backend_url       = "https://example.dspace.org/server"
  cluster_id        = var.cluster_id
  db_host           = var.db_host # db hostname
  db_name           = var.db_name # db name (will be created if not exists)
  db_password_arn   = var.db_password_param # SSM param name containing password
  db_username_arn   = var.db_username_param # SSM param name containing username
  efs_id            = var.efs_id
  frontend_url      = "https://example.dspace.org"
  host              = "example.dspace.org"
  img               = var.backend_img
  listener_arn      = var.listener_arn
  listener_priority = 1
  log_group         = var.log_group_name
  name              = "demo-backend"
  namespace         = "/server"
  security_group_id = data.aws_security_group.selected.id
  solr_url          = "http://demo-solr.dspace.solr:8983/solr"
  subnets           = var.subnets
  timezone          = "America/New_York"
  vpc_id            = var.vpc_id

  depends_on = [module.solr]
}
```

Given this example, the backend would be available at:

- `https://example.dspace.org:8983/server`

For all configuration options review the [variables file](modules/backend/variables.tf).

### Frontend

```hcl
TODO
```
