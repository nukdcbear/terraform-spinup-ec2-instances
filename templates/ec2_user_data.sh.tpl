#!/bin/bash
# Show file was used
echo "${motd}" > /etc/motd

echo "${machine_cert}" > /etc/ssl/certs/${hostname}.pem
chmod 0644 /etc/ssl/certs/${hostname}.pem
echo "${cert_key}" > /etc/ssl/private/${hostname}.key
chmod 0600 /etc/ssl/private/${hostname}.key