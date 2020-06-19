# Terraform Spinup EC2 Instances

## Table of Contents

- [Terraform Spinup EC2 Instances](#terraform-spinup-ec2-instances)
  - [Table of Contents](#table-of-contents)
  - [About <a name = "about"></a>](#about)
  - [Requirements <a name = "requirements"></a>](#requirements)
  - [System Requirements <a name = "system-requirements"></a>](#system-requirements)
  - [Usage <a name = "usage"></a>](#usage)

## About <a name = "about"></a>

Example Terraform code to spinup EC2 instances creating Route53 records for the instance.

This example is using a NGINX Ubuntu based AMI and will interact with Venafi DevOpsACCELERATE to generate a test cert and configure the NGINX instance for https.

## Requirements <a name = "requirements"></a>

- HashiCorp [Terraform, >v0.12.0](https://www.terraform.io/downloads.html)
- [AWS Account](https://aws.amazon.com/console/)
- [Venafi DevOpsACCELERATE (cloud) account](https://ui.venafi.cloud/login)

## System Requirements <a name = "system-requirements"></a>

This can be executed on either a Windows or Linux system

Must set environment variables for AWS credentials; access key and secret key and Venafi credentials; api and zone.

AWS S3 bucket for backend state storage.

Ubuntu based AMI with NGINX installed

## Usage <a name = "usage"></a>

```bash
# Clone the respository
git clone git@github.com:nukdcbear/terraform-spinup-ec2-instances.git

# cd in the directory
cd terraform-spinup-ec2-instances

# Execute Terraform
terraform init -backend-config="<AWS S3 bucket>" -backend-config="key=<tfstate path/file>"
terraform plan -out=mytfplan
terraform apply mytfplan
```