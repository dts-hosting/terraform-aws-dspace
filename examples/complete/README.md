# Complete DSpace example

Configuration in this directory creates a full DSpace deployment.

## Usage

To run this example you need to create `terraform.tfvars`:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update the values as appropriate:

```bash
backend_img        = "dspace/dspace:dspace-7_x"
certificate_domain = "*.dspace.org"
domain             = "dspace.org"
frontend_img       = "dspace/dspace-angular:dspace-7_x-dist"
profile            = "default"
profile_for_dns    = "default"
solr_img           = "dspace/dspace-solr:dspace-7_x"
```

The key ones are:

- `certificate_domain`
  - this must be available as an ACM cert in your `profile` account
- `domain`
  - this is the domain to use for public DNS
  - you must have a Route53 hosted zone available for this domain
- `profile_for_dns`
  - set to a different profile if necessary
  - this profile should contain the hosted zone for `domain`

Then execute:

```bash
terraform init
terraform plan
terraform apply
```

The example site will be available at: `https://dspace-ex-complete.${domain}`

Note that this example creates resources which cost money. Run terraform destroy
when you don't need these resources.
