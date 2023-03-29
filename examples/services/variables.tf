variable "backend_img" {
  default = "dspace/dspace:dspace-7_x"
}

variable "domain" {
  default = "dspace.org"
}

variable "frontend_img" {
  default = "dspace/dspace-angular:dspace-7_x-dist"
}

variable "profile" {
  default = "default"
}

variable "profile_for_dns" {
  default = "default"
}

variable "solr_img" {
  default = "dspace/dspace-solr:dspace-7_x"
}
