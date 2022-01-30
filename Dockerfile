FROM alpine:3.15
LABEL maintainer="Hetao<hetao@hetao.name>"
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
	&& apk update \
	&& apk add tzdata  \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& echo "Asia/Shanghai" > /etc/timezone

#install nginx and php7
RUN apk add nginx 
RUN apk add php7-pear php7-dev php7-cli php7-fpm php7-imap php7-mbstring php7-json php7-common php7-pecl-redis php7-pecl-mcrypt php7-ldap php7-pdo_mysql php7-mysqlnd php7-mysqli php7-bcmath php7-curl php7-opcache php7-gd php7-xml php7-simplexml php7-iconv php7-openssl php7-pecl-imagick php7-session php7-zip php7-ftp php7-pcntl php7-sockets php7-gettext php7-exif php7-tokenizer 

#install grpc and swoole
RUN apk add zip composer git gcc autoconf make g++ m4 automake libtool linux-headers
RUN pecl channel-update pecl.php.net
RUN pecl install grpc
#https://wiki.swoole.com/#/environment?id=pecl
RUN apk add openssl-dev
RUN pecl install -D 'enable-http2="yes" enable-openssl="yes"'  swoole


#mkdir default config
RUN mkdir -p /data/www \
    && cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak \
    && cp /etc/php7/php.ini /etc/php7/php.ini.bak \
    && cp /etc/php7/php-fpm.conf  /etc/php7/php-fpm.conf.bak \
    && cp /etc/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf.bak

WORKDIR /data/www/

COPY docker/start.sh start.sh
COPY docker/nginx/nginx.conf /etc/nginx/
COPY docker/nginx/sites-enabled/* /etc/nginx/sites-enabled/
COPY docker/fpm/php.ini /etc/php7/php.ini
COPY docker/fpm/php-fpm.conf /etc/php7/php-fpm.conf
COPY docker/fpm/pool.d/www.conf /etc/php7/php-fpm.d/www.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

COPY index.php .

RUN php -m

#代码检查
RUN find app -type f -name '*.php' -exec php -l {} \; | (! grep -v "No syntax errors detected" )

HEALTHCHECK --interval=5s --timeout=5s --retries=3 \
    CMD ps aux | grep "php-fpm:" | grep -v "grep" > /dev/null; if [ 0 != $? ]; then exit 1; fi
EXPOSE 80
CMD ["/bin/sh","/data/www/start.sh"]
