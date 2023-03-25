# DSpace Terraform modules

Terraform modules to deploy [DSpace](https://dspace.lyrasis.org/) as
[AWS ECS](https://aws.amazon.com/ecs/) services.

## Requirements

As a group the modules require (but do not create):

- A VPC
- 2+ subnets within the VPC
- 1+ security group/s that allows ingress from within the VPC
- An application load balancer assigned to public subnets in the VPC
- EFS storage for persistent data permitting access from within the VPC
- ECS cluster / autoscaling group (latter optional if using Fargate)
- Postgres database (RDS or other) connection details
- Solr connection details (or service discovery if using the included module)
- DNS records (Route53 or other) for publicly accessible DSpace services

These resources can be created however you like and are broadly outlined
as implementation details can vary (whether to use public vs. private
subnets with a NAT gateway; the specifics of how security groups are
defined, and so on).

The example projects show different ways that externally created resources
can be used with this module.

## Examples

- [Complete DSpace example generating all resources (except DNS record)](examples/complete)
- [Using pre-existing resources example as inputs to DSpace modules](examples/services)

## Usage

```bash
TODO
```
