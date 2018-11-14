FROM ubuntu:xenial
LABEL maintainer "aiminick@qq.com"
WORKDIR /opt
ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial main restricted' > /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial-updates main restricted' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial universe' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial-updates universe' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial-updates multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial-backports main restricted universe multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial-security main restricted' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial-security universe' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.163.com/ubuntu/ xenial-security multiverse' >> /etc/apt/sources.list 

RUN set -ex \
    && apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends apt-utils software-properties-common \
    && add-apt-repository ppa:jonathonf/python-3.6 -y && apt-get update && apt-get upgrade -y 
    
RUN set -ex \
    && apt-get install -y --no-install-recommends \
    language-pack-zh-hans wget libkrb5-dev libsqlite3-dev gcc make automake libssl-dev zlib1g-dev libmysqlclient-dev libffi-dev git \
    xz-utils default-jre default-jdk libtool autoconf libcairo2-dev libjpeg-turbo8-dev libpng12-dev libossp-uuid-dev libavcodec-dev \
    libavutil-dev libswscale-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libpulse-dev libssl-dev \
    libvorbis-dev libwebp-dev ghostscript unzip vim curl net-tools iputils-ping dnsutils mysql-server redis-server netbase nginx \
    openssh-server ssh \
    python3.6 python3.6-dev python3.6-venv ; chown mysql:mysql -R /var/lib/mysql 

RUN set -ex \
    && export LC_ALL=zh_CN.UTF-8 \
    && echo 'LANG="zh_CN.UTF-8"' > /etc/default/locale \
    && ln -sf /usr/local/lib/freerdp /usr/lib/x86_64-linux-gnu/freerdp 
    
RUN set -ex \
    && cd /opt && python3.6 -m venv /opt/py3 \
    && . /opt/py3/bin/activate \
    && /opt/py3/bin/pip install --upgrade pip setuptools -i https://mirrors.aliyun.com/pypi/simple/ \
    && git clone https://github.com/kennethreitz/autoenv.git \
    && echo '. /opt/autoenv/activate.sh' >> ~/.bashrc \
    && echo '. /opt/autoenv/activate.sh' >> /etc/profile 

RUN set -ex \
    && wget https://github.com/aiminickwong/gitrepo/raw/master/jumpserver-1.4.4.zip \
    && unzip jumpserver-1.4.4.zip && rm -rf jumpserver-1.4.4.zip \
    && apt-get install -y --no-install-recommends  $(cat /opt/jumpserver/requirements/deb_requirements.txt) 
    
RUN set -ex \
    && cd /opt && python3.6 -m venv /opt/py3 \
    && . /opt/py3/bin/activate \
    && /opt/py3/bin/pip install -r /opt/jumpserver/requirements/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ 

RUN set -ex \
    && cd /opt && python3.6 -m venv /opt/py3 \
    && . /opt/py3/bin/activate \
    && wget https://github.com/jumpserver/coco/archive/v1.4.4.tar.gz \
    && tar xvf v1.4.4.tar.gz && mv coco-1.4.4 coco && rm -rf v1.4.4.tar.gz \
    && /opt/py3/bin/pip install -r /opt/coco/requirements/requirements.txt \
    && mkdir -p /opt/coco/keys && mkdir -p /opt/coco/logs 

RUN set -ex \
    && wget https://github.com/aiminickwong/gitrepo/raw/master/jumpserver-luna-v1.4.4.zip \
    && unzip jumpserver-luna-v1.4.4.zip && rm -rf jumpserver-luna-v1.4.4.zip \
    && chown -R root:root luna 
    
RUN set -ex \
    && git clone https://github.com/jumpserver/docker-guacamole.git && cd docker-guacamole \
    && tar xf guacamole-server-0.9.14.tar.gz && cd guacamole-server-0.9.14 \
    && autoreconf -fi && ./configure --with-init-dir=/etc/init.d && make -j4 && make install \
    && cd .. && rm -rf guacamole-server-0.9.14 && ldconfig \
    && mkdir -p /config/guacamole /config/guacamole/lib /config/guacamole/extensions \
    && cp /opt/docker-guacamole/guacamole-auth-jumpserver-0.9.14.jar /config/guacamole/extensions/ \
    && cp /opt/docker-guacamole/root/app/guacamole/guacamole.properties /config/guacamole/ \
    && cd /opt 

RUN set -ex \
    && cd /config \
    && wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.35/bin/apache-tomcat-8.5.35.tar.gz \
    && tar xvf apache-tomcat-8.5.35.tar.gz && rm -rf apache-tomcat-8.5.35.tar.gz \
    && mv apache-tomcat-8.5.35 tomcat8 && rm -rf /config/tomcat8/webapps/* 2>/dev/null ; mkdir -p /config/tomcat8/webapps 2>/dev/null ; \
    cp -rf /opt/docker-guacamole/guacamole-0.9.14.war /config/tomcat8/webapps/ROOT.war \
    && sed -i 's/Connector port="8080"/Connector port="8081"/g' `grep 'Connector port="8080"' -rl /config/tomcat8/conf/server.xml` \
    && sed -i 's/FINE/ERROR/g' `grep 'FINE' -rl /config/tomcat8/conf/logging.properties` \
    && export JUMPSERVER_KEY_DIR=/config/guacamole/keys \
    && echo "export JUMPSERVER_KEY_DIR=/config/guacamole/keys" >> ~/.bashrc \
    && echo "export JUMPSERVER_KEY_DIR=/config/guacamole/keys" >> /etc/profile \
    && export GUACAMOLE_HOME=/config/guacamole \
    && echo "export GUACAMOLE_HOME=/config/guacamole" >> ~/.bashrc \
    && echo "export GUACAMOLE_HOME=/config/guacamole" >> /etc/profile \
    && cd /opt 
    
RUN set -ex \
    && apt-get clean && apt-get clean all && cd /opt ; \
    systemctl disable guacd 2>/dev/null ; \
    systemctl disable redis-server 2>/dev/null ; \
    systemctl disable mysql 2>/dev/null ; \
    systemctl disable nginx 2>/dev/null ; \
    echo "Base OS Done!" 

