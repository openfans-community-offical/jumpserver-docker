FROM aiminick/jumpserver-base:latest
LABEL maintainer "aiminick@qq.com"
WORKDIR /opt

ENV LC_ALL=zh_CN.UTF-8

VOLUME /opt/sslcrt
ENV VARC=CN
ENV VARST=Sichuan
ENV VARL=Chengdu
ENV VARO=OPENFANS.ORG
ENV VAROU=CecOS
ENV VARCN=jumpserver
ENV VARMAIL=admin@openfans.org

RUN set -ex \
    && export LC_ALL=zh_CN.UTF-8 && rm -rf ~/.cache/pip 2>/dev/null
    
COPY mysql_init.sh mysql_init.sh

RUN set -ex \
    && sh /opt/mysql_init.sh && rm -rf /opt/mysql_init.sh && rm -rf /etc/nginx/sites-enabled/default \
    && mkdir -p /opt/sslcrt

COPY jpcf.py jumpserver/config.py
COPY cocf.py coco/conf.py
COPY nginx.conf /etc/nginx/sites-enabled/default
COPY entrypoint.sh /bin/entrypoint.sh
COPY readme.txt readme.txt
COPY note.txt note.txt

RUN chmod +x /bin/entrypoint.sh

VOLUME /opt/jumpserver/data
VOLUME /opt/coco/keys
VOLUME /config/guacamole/keys
VOLUME /var/lib/mysql

ENV DB_ENGINE=mysql \
    DB_HOST=127.0.0.1 \
    DB_PORT=3306 \
    DB_USER=jumpserver \
    DB_PASSWORD=P@ssword01!@jumpServer \
    DB_NAME=jumpserver

ENV REDIS_HOST=127.0.0.1 \
    REDIS_PORT=6379 \
    REDIS_PASSWORD=
    
ENV JUMPSERVER_KEY_DIR=/config/guacamole/keys \
    GUACAMOLE_HOME=/config/guacamole \
    JUMPSERVER_ENABLE_DRIVE=true \
    JUMPSERVER_SERVER=http://127.0.0.1:8080

EXPOSE 2222 443
ENTRYPOINT ["entrypoint.sh"]
