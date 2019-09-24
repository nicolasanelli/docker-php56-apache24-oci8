# Dockerfile para o Qualis
FROM ubuntu:16.04

# Configurando variáveis de ambiente
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV TZ=America/Sao_Paulo

# Atualizando o repositório
RUN apt-get update

# Configurando o timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    apt-get install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

# Instalando o repositório do ondrej para instalação do php56
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update

# Instalando ferramentas básicas
RUN apt-get install -y vim wget zip

# Instalando o php-5.6
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

# Instalando pdftk
RUN apt-get install -y \
	libgcj-common \
    pdftk

# Instalando o toolkit que contém o pdftotext
RUN apt-get install -y \
    poppler-utils

# Instalando o apache server
RUN apt-get install -y \
    apache2 \
    libapache2-mod-php5.6
RUN a2enmod rewrite

# Instalando ferramentas/binários legado
RUN apt-get install -y \
    bc \
    libaio-dev

# Removendo dados do apt-get para diminuir tamanho da imagem
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp*

# Instalando o InstantCliente Oracle Conector
RUN mkdir -p /home/instant_client/
COPY instant_client /home/instant_client
RUN ln -sfn /home/instant_client/libclntsh.so.12.1 /home/instant_client/libclntsh.so && \
    echo 'instantclient,/home/instant_client' | pecl install oci8-2.0.12 && \
    echo 'extension=oci8.so' >> /etc/php/5.6/apache2/php.ini && \
    echo 'extension=oci8.so' >> /etc/php/5.6/cli/php.ini

# Para auxiliar na criação do dockerfile
RUN echo "<?php phpinfo(); ?>" >> /var/www/html/index.php
RUN rm /var/www/html/index.html

