# DSpace Terraform modules

Terraform modules to deploy [DSpace](https://dspace.lyrasis.org/) as
[AWS ECS](https://aws.amazon.com/ecs/) services.

- [General infrastructure requirements](REQS.md)

## Examples

- [Complete DSpace example generating all resources](examples/complete)
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

Run the DSpace backend (REST API server).

Configuration for the DSpace backend:

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
}
```

Given this example, the backend would be available at:

- `https://example.dspace.org/server`

For all configuration options review the [variables file](modules/backend/variables.tf).

#### Tasks

The `tasks` variable can be used to schedule commands that run inside dedicated,
transitory container instances, (therefore there should be no impact on the web
based services). _This requires Fargate compatibility to be enabled on the cluster._

```hcl
tasks = {
  reindex = {
    args     = ["/dspace/bin/dspace", "index-discovery", "-b"]
    schedule = "cron(0 6 * * ? *)" # UTC timezone
  }
}
```

- name of the task
  - `args`: list of (string) arguments to a valid command within the container
  - `schedule`: CloudWatch [schedule expression](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)

### Frontend

Configuration for the DSpace frontend (Angular UI):

```hcl
module "frontend" {
  source = "../../modules/frontend"

  cluster_id        = var_efs_id
  host              = "example.dspace.org"
  img               = var.frontend_img
  listener_arn      = var.listener_arn
  listener_priority = 2
  log_group         = var.log_group_name
  name              = "demo-frontend"
  namespace         = "/"
  rest_host         = "example.dspace.org"
  rest_namespace    = "/server"
  security_group_id = data.aws_security_group.selected.id
  subnets           = data.aws_subnets.selected.ids
  vpc_id            = data.aws_vpc.selected.id
}
```

Given this example, the frontend would be available at:

- `https://example.dspace.org`

For all configuration options review the [variables file](modules/frontend/variables.tf).
