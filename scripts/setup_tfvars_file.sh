#!/bin/bash

hostname=${hostname:-dev-domo99}
route53_hosted_zone_name=${domain_name:-davidcbarringer.com}

while [ $# -gt 0 ]; do

    case "$1" in
        --hostname=*)
          hostname="${1#*=}"
          ;;
        --domain_name=*)
          route53_hosted_zone_name="${1#*=}"
          ;;
        *)
          printf "***************************\n"
          printf "* Error: Invalid argument.*\n"
          printf "***************************\n"
          exit 1
        esac
    shift
done

server_FQDN="$hostname.$route53_hosted_zone_name"

echo -e "hostname = \"$hostname\"\nroute53_hosted_zone_name = \"$route53_hosted_zone_name\"\nserver_FQDN = \"$server_FQDN\"\n" > myterraform.tfvars
