FROM ubuntu:xenial
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y vim wget apache2 libssl1.0.0 \
    && wget https://s3.eu-west-2.amazonaws.com/uk.ac.cam.uis.mws/libapache2-mod-ucam-webauth_2.0.5apache24_ubuntu-16.04_amd64.deb \
    && dpkg -i libapache2-mod-ucam-webauth_2.0.5apache24_ubuntu-16.04_amd64.deb \
    && rm -f libapache2-mod-ucam-webauth_2.0.5apache24_ubuntu-16.04_amd64.deb \
    && a2enmod proxy proxy_connect proxy_http rewrite ssl ucam_webauth authnz_ldap ldap \
    && a2dissite 000-default \
    && apt-get autoclean \
    && mkdir -p /etc/apache2/conf/webauth_keys \
    && cd /etc/apache2/conf/webauth_keys \
    && wget https://raven.cam.ac.uk/project/keys/pubkey2

ADD entrypoint.sh /usr/local/bin
ADD ./sites/ /etc/apache2/sites-enabled/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
