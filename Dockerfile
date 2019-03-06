FROM nginx:stable

ENV URL localhost
ENV EMAIL test@test.com

RUN apt-get update && apt-get upgrade
RUN apt-get install -y software-properties-common gpg
RUN add-apt-repository -y ppa:certbot/certbot
RUN apt-get install -y python-certbot-nginx

COPY startup.sh /

CMD ["bash", "/startup.sh"]