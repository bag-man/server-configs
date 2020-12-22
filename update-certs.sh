#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
systemctl stop varnish
certbot renew --deploy-hook="/usr/bin/hitch-deploy-hook" --post-hook="systemctl reload hitch" --force-renewal
systemctl start varnish

#/usr/bin/hitch-deploy-hook
#!/bin/bash
#if [[ "${RENEWED_LINEAGE}" == "" ]]; then
#    echo "Error: missing RENEWED_LINEAGE env variable." >&2
#    exit 1
#fi
#
#umask 077
#cat ${RENEWED_LINEAGE}/privkey.pem \
#${RENEWED_LINEAGE}/fullchain.pem \
#${dhparams} > ${RENEWED_LINEAGE}/hitch.pem
