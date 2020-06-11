FROM php:7.2-apache

# Install extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        wget \
        certbot \
        python-certbot-apache\
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Prepare files and folders

RUN mkdir -p /speedtest/

# Copy sources
COPY backend/ /speedtest/backend

COPY results/*.php /speedtest/results/
COPY results/*.ttf /speedtest/results/

COPY *.js /speedtest/
COPY docker/servers.json /servers.json

COPY docker/*.php /speedtest/
COPY docker/entrypoint.sh /

# Prepare environment variabiles defaults

ENV TITLE=ZebraHost Speed Test
ENV MODE=standalone
ENV PASSWORD=password
ENV TELEMETRY=true
ENV ENABLE_ID_OBFUSCATION=true
ENV REDACT_IP_ADDRESSES=false
ENV WEBPORT=80
ENV DOMAIN=kansascity.speedtest.zerbahost.com
ENV EMAIL=support@zebrahost.com
# Final touches

EXPOSE 80
CMD ["bash", "/entrypoint.sh"]
