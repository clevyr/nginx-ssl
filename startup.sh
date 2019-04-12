set -e

cmd="$@"

if [ $AUTH == "true" ]; then
    if [ $PASSWORD == "password" ]; then
        >&2 echo "Don't use a bad password, you know better"
        exit
    fi
    SHA1PASS=$(echo -n ${PASSWORD} | openssl sha1 -r | head -c 40 | awk '{ print toupper($0) }')
    KANON=$(echo -n ${SHA1PASS} | head -c 5 | awk '{ print toupper($0) }')
    HASHES=$(curl https://api.pwnedpasswords.com/range/${KANON})
    while read -r line; do
        SUM=$(echo -n "$line" | head -c 35)
        if [ $SHA1PASS == "${KANON}${SUM}" ]; then
            >&2 echo "This password has been compromised before"
            exit
        fi
    done <<< "$HASHES"
    echo ${USERNAME}:$(openssl passwd -apr1 ${PASSWORD}) >> /etc/nginx/.htpasswd
    sed -i '/location/a auth_basic "Restricted Content";\nauth_basic_user_file /etc/nginx/.htpasswd;' /etc/nginx/conf.d/default.conf
    >&2 echo "Authentication is set"
fi

domainString=""
IFS=';' read -r -a domains <<< "$URL"
for domain in "${domains[@]}"
do
    echo "$domain"
    domainString="$domainString -d $domain"
done

certbot --nginx -m $EMAIL $domainString --agree-tos -n --redirect
killall nginx

>&2 echo "SSL Certs are created"

>&2 echo "Starting nginx"
nginx -g "daemon off;"
