FROM ubuntu:16.04
MAINTAINER nicolasanelli

# Setting environment vars
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# Updating apt repo
RUN apt-get update

# Adding ondrej/php PPA for php5.6 version
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update

# Installing common tools
RUN apt-get install -y vim wget zip

# Installing PHP-5.6 and some extensions
RUN apt-get install -y \
    php5.6 \
    php5.6-cgi \
    php5.6-cli \
    php5.6-common \
    php5.6-fpm \
    php5.6-mbstring \
    php5.6-curl \
    php5.6-dev \
    php5.6-gd \
    php5.6-xml \
    php5.6-mcrypt \
    php5.6-xmlrpc \
    php5.6-ldap \
    php5.6-zip \
    php-pear

# Installing PDFTK
RUN apt-get install -y \
	libgcj-common \
    	pdftk

# Installing poppler-utils (pdftotext)
RUN apt-get install -y \
    poppler-utils

# Installing apache http server
RUN apt-get install -y \
    apache2 \
    libapache2-mod-php5.6
RUN a2enmod rewrite

# Installing legacy libs for oci and pdf manipulation
RUN apt-get install -y \
    bc \
    libaio-dev

# Cleaning apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp*

# Installing instant-client Oracle Conector
RUN mkdir -p /home/instant_client/
COPY instant_client /home/instant_client
RUN ln -sfn /home/instant_client/libclntsh.so.12.1 /home/instant_client/libclntsh.so && \
    echo 'instantclient,/home/instant_client' | pecl install oci8-2.0.12 && \
    echo 'extension=oci8.so' >> /etc/php/5.6/apache2/php.ini && \
    echo 'extension=oci8.so' >> /etc/php/5.6/cli/php.ini

# Helper index page
RUN echo "<?php phpinfo(); ?>" >> /var/www/html/index.php
RUN rm /var/www/html/index.html

