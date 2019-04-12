# clevyr/nginx-ssl

## Usage

This is the `nginx:latest` Docker image with SSL support

Make a volume to persist /etc/letsencrypt, and /etc/cron.d

Use the `URL` env var to declare what url the certificate needs to be created for. You can use semicolons to separate multiple urls
Use the `EMAIL` env var to declare the email used for alerts

This image does not send your email to the EFF, and it assumes you agree to the TOS of Certbot

Change `/etc/nginx/conf.d/default.conf` if you need to customize the image, the default is below:

```nginx
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```