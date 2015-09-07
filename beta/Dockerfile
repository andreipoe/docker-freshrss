FROM php:5.6-apache
MAINTAINER Guillaume Fillon <guillaume@posteo.de>

ENV FRSS_HOME="/var/www/html" \
    FRSS_LOG_DIR="/var/log/freshrss" \
    FRSS_SETUP_DIR="/data"

ENV FRSS_DATA_DIR="${FRSS_HOME}/data"

RUN apt-get update \
    && apt-get install -y libcurl4-openssl-dev libjpeg62-turbo-dev \
        libmcrypt-dev libpng12-dev libicu-dev libgmp-dev libsqlite3-dev \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && docker-php-ext-install curl mbstring gd intl mysql json zip gmp \
       			      pdo pdo_mysql pdo_sqlite \
    && rm -rf /var/lib/apt/lists/*

COPY freshrss ${FRSS_HOME}
COPY freshrss/data ${FRSS_SETUP_DIR}

RUN chown -R :www-data ${FRSS_HOME} \
    && chmod -R g+w ${FRSS_DATA_DIR}

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80/tcp

VOLUME ["${FRSS_DATA_DIR}", "${FRSS_LOG_DIR}"]
WORKDIR ${FRSS_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]
