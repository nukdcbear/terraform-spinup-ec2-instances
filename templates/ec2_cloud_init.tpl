#cloud-config
fqdn: ${hostname}

# write_files:
# - content: |
#     {machine_cert}
#   path: /etc/ssl/certs/{hostname}.pem
#   permssions: 0644

# - content: |
#     {cert_key}
#   path: /etc/ssl/private/{hostname}.key
#   permissions: 0644