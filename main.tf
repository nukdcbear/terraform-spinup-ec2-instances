locals {
  common_tags = {
    Environment = "dev"
    Owner       = var.owner_team
  }
}

# -----------------------------------------------------------------------------
# Venafi cert
# -----------------------------------------------------------------------------
resource "venafi_certificate" "domo" {
  common_name = var.server_FQDN
}

# -----------------------------------------------------------------------------
# Cloud Init
# -----------------------------------------------------------------------------
data "template_file" "user_data_script" {
  template = file("${path.module}/templates/ec2_user_data.sh.tpl")
  vars     = {
    hostname = var.server_FQDN
    machine_cert = venafi_certificate.domo.certificate
    cert_key = venafi_certificate.domo.private_key_pem
    motd = <<-EOF
  Domo machine
EOF
  }
}

data "template_file" "init" {
  template =  file("${path.module}/templates/ec2_cloud_init.tpl")
  vars     = {
    hostname = var.server_FQDN
    # machine_cert = venafi_certificate.domo.certificate
    # cert_key = venafi_certificate.domo.private_key_pem
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data_script.rendered
  }
}

# -----------------------------------------------------------------------------
# AMIs
# -----------------------------------------------------------------------------
data "aws_ami" "ubuntu_18" {
  most_recent = true
  owners      = ["099720109477"]  # Official Canonical https://help.ubuntu.com/community/EC2StartersGuide

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# -----------------------------------------------------------------------------
# EC2 Instance
# -----------------------------------------------------------------------------
resource "aws_instance" "domo_machines" {
  ami                         = data.aws_ami.ubuntu_18.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.domo.id]
  subnet_id                   = var.aws_vpc_subnet_id
  user_data_base64            = data.template_cloudinit_config.config.rendered

  tags = merge(
    {
      "Name" = format("%s-%s", var.hostname, var.owner_team)
    },
    local.common_tags,
  )
}

resource "aws_security_group" "domo" {
  name        = "domo-vpc"
  description = "Rules for domo vpc"
  vpc_id      = var.aws_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.domo_ingress_cidr_block]  # Specific cidr to limit access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_route53_zone" "selected" {
  count        = var.route53_hosted_zone_name != "" ? 1 : 0
  name         = var.route53_hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "domo_machines" {
  count   = var.route53_hosted_zone_name != "" ? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.server_FQDN
  type    = "A"
  records = [aws_instance.domo_machines.public_ip]
  ttl     = "300"
}
