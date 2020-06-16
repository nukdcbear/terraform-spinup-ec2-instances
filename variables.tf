# variable "ami_id" {
#   default = "ami-094375c3740af33f3"
# }

variable "aws_vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "aws_vpc_subnet_id" {
  default = "subnet-06d2f1d8a5a619fab"
}

variable "aws_vpc_id" {
  default = "vpc-0e2a0b0d235345dd2"
}

variable "domo_ingress_cidr_block" {
  default = "65.189.75.0/24"
}

variable "hostname" {
  description = "Simple name for machine"
  default     = "dev-domo1"
}

variable "key_pair_name" {
  description = "SSH key pair"
  default     = "dcb-ec2keypair-pem"
}

variable "route53_hosted_zone_name" {
  type        = string
  description = "Route53 Hosted Zone where domo machines will reside"
  default     = "davidcbarringer.com"
}

variable "server_FQDN" {
  description = "Server fully qualifed domain name"
  default     = "dev-domo1.davidcbarringer.com"
}

variable "owner_team" {
  description = "Name of team owning resources"
  default     = "DomoVenafiTeam"
}