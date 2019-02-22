FROM centos:6
MAINTAINER Carlos Vaz carlosjvaz@gmail.com

# UPDATE
RUN yum -y update

# TOOLS
RUN yum install -y curl git wget unzip make openssl-devel

# APACHE
RUN yum install -y httpd

# PHP
RUN yum install -y \
    php \
    php-cli \
    php-devel \
    php-gd  \
    php-imap  \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-pdo \
    php-pear  \
    php-pecl-memcache \
    php-pecl-xdebug \
    php-pgsql \
    php-process \
    php-recode \
    php-redis \
    php-snmp \
    php-soap \
    php-sqlite  \
    php-xcache \
    php-xml \
    php-xmlrpc

RUN sed -i 's/;date.timezone =.*/date.timezone = "America\/Sao_Paulo"/' /etc/php.ini &&\    
    sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /etc/php.ini &&\
    sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini &&\
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini &&\
    sed -i 's/short_open_tag = Off/short_opeRUN a2enmod rewriten_tag = On/' /etc/php.ini &&\
    echo "xdebug.remote_port=9000" >> /etc/php.d/xdebug.ini &&\
    echo "xdebug.remote_enable=on" >> /etc/php.d/xdebug.ini &&\
    echo "xdebug.remote_autostart=off" >> /etc/php.d/xdebug.ini &&\
    echo "xdebug.remote_connect_back = 1" >> /etc/php.d/xdebug.ini &&\
    echo "xdebug.remote_log=/var/log/xdebug.log" >> /etc/php.d/xdebug.ini


## CLEAN UP
RUN yum install -y yum-utils
RUN package-cleanup --dupes
RUN package-cleanup --cleandupes
RUN yum clean all

# WORK FOLDER
RUN mkdir -p /var/www/html
RUN chown -R apache:apache /var/www/html
VOLUME ["/var/www/html"]

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart 
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh
CMD ["/run-httpd.sh"]