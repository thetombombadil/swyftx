#!/bin/sh

cd /tmp 
sudo yum install -y https://s3.amazonaws.com/ec2-downloads
windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm 
sudo systemctl enable amazon-ssm-agent 
sudo systemctl start amazon-ssm-agent

sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl start nginx

# # get instance ID
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"

# create page with ID
sudo mkdir -p /var/www/webpage
sudo touch /var/www/webpage/index.html
# cd /var/www/webpage
sudo cat <<EOT > /var/www/webpage/index.html
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>$EC2_INSTANCE_ID</title>
</head>
<body>
    <h1>Hello! My instance id is: $EC2_INSTANCE_ID</h1>
</body>
</html>
EOT

# update nginx config
sudo cat <<EOT > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /var/www/webpage;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
}
EOT

nginx -s reload