set -e

cmd="$@"

domainString=""
IFS=';' read -r -a domains <<< "$URL"
for domain in "${domains[@]}"
do
    echo "$domain"
    domainString="$domainString -d $domain"
done

certbot --nginx -m $EMAIL $domainString --agree-tos -n --redirect
killall nginx

>&2 echo "SSL Certs are created - executing command"

nginx -g "daemon off;"
