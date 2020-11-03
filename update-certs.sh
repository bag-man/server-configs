systemctl stop varnish
certbot certonly
cat privatekey.pem fullchain.pem > hitch.pem
systemctl start varnish
systemctl restart hitch
