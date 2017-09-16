FROM debian:stretch-slim
ENV UNIT_VERSION 0.1

RUN echo "deb http://ftp.cn.debian.org/debian stretch main" > /etc/apt/sources.list \
&& echo "deb http://ftp.cn.debian.org/debian stretch-updates main" >> /etc/apt/sources.list \
&& echo "deb http://security.debian.org stretch/updates main" >> /etc/apt/sources.list \
&& apt-get update \
&& apt-get install -y \
                gcc \
                gettext \
                sqlite3 build-essential wget curl \
                python-dev php-dev libphp-embed python-pip\
        --no-install-recommends && rm -rf /var/lib/apt/lists/* \
&& cd /tmp && wget  -O - "http://unit.nginx.org/download/unit-$UNIT_VERSION.tar.gz" | tar  xvz   \
&& cd unit-$UNIT_VERSION \
&& ./configure --prefix=/usr  --modules=lib --control='*:8000' --log=/dev/stdout --pid=/var/run/unitd.pid \
&& ./configure python --module=py27\
&& ./configure php --module=php70\
&& make install \
&& rm -rf /tmp/unit-$UNIT_VERSION \
&& apt-get remove --auto-remove -y  build-essential wget \
&& mkdir /www

WORKDIR /www

EXPOSE 8000

#CMD ["/usr/sbin/unitd"]