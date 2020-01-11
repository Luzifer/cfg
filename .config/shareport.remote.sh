function gen_prefix() {
	cat /dev/urandom | tr -dc 'a-z0-9' | head -c 8 || true
}

# Generate an unique ID and set config path for it
share_id=${FQDN_PREFIX:-}
while :; do
	config_file="/home/shareport/nginx/shareport_${share_id}.conf"

	if [[ -z $share_id ]] || [[ -e $config_file ]]; then
		share_id=$(gen_prefix)
		continue
	fi

	break
done

# Ensure configuration directory is there
mkdir -p $(dirname ${config_file})

# Create nginx configuration for new share
cat -s <<EOF >${config_file}
server {
  listen        443 ssl http2;
  server_name   ${share_id}.knut.dev;
  
  ssl_certificate     /data/ssl/nginxle/knut.dev.pem;
  ssl_certificate_key /data/ssl/nginxle/knut.dev.key;
  
  location / {
    proxy_pass          http://${LISTEN};
    proxy_set_header    Upgrade \$http_upgrade;
    proxy_set_header    Connection "Upgrade";
    proxy_set_header    Host \$host;
    proxy_set_header    X-Real-IP \$remote_addr;
    proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header    X-Forwarded-Proto \$scheme;
  }
}
EOF

# Register cleanup for script exit
function cleanup() {
	rm -f \
		${config_file}
	sudo /bin/systemctl reload nginx.service
}
trap cleanup EXIT

# Reload nginx to apply new config
sudo /bin/systemctl reload nginx.service

# Let user know where to look
echo
echo "Listening on https://${share_id}.knut.dev/"
echo

# Keep active until program exits
while :; do sleep 5m; done
