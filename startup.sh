set -e

cmd="$@"

domainString=""
IFS=';' read -r -a domains <<< "$URL"
for domain in "${domains[@]}"
do
    echo "$domain"
    domainString="$domainString -d $domain"
done

echo "$domainString"

echo "certbot --nginx -m $EMAIL $domainString --agree-tos -n --redirect"

>&2 echo "SSL Certs are created - executing command"

nginx -g "daemon off;"
