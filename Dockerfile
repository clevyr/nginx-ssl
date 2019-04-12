FROM nginx:stable

ENV URL localhost
ENV EMAIL test@test.com
ENV AUTH false
ENV USERNAME username
ENV PASSWORD password

RUN apt-get update \
    && apt-get upgrade \
    && apt-get install -y software-properties-common gpg curl \
    && add-apt-repository -y ppa:certbot/certbot \
    && apt-get install -y python-certbot-nginx \
    && rm -rf /var/lib/apt/lists/*

COPY startup.sh /

CMD ["bash", "/startup.sh"]