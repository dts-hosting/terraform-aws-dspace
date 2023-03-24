# DSpace Terraform module

Terraform module to deploy [DSpace](https://dspace.lyrasis.org/) as
[AWS ECS](https://aws.amazon.com/ecs/) services.

## Requirements

This module requires (and does not create):

- A VPC
- 2+ subnets within the VPC
- 1+ security group/s that allows ingress from within the VPC
- An application load balancer assigned to public subnets in the VPC
- EFS storage for persistent data permitting access from within the VPC
- ECS cluster / autoscaling group (latter optional if using Fargate)
- Postgres database (RDS or other) connection details
- Solr connection details (or service discovery if using the included module)
- DNS records (Route53 or other) for publicly accessible DSpace services

These resources can be created however you like and are broadly defined to
provide a set of general guidelines as implementation details can vary (i.e.
whether to use public vs. private subnets with a NAT gateway; the specifics
of how security groups are defined, and so on).

The example project represents one way externally created resources
can be used with this module.

## Usage

- TODO
