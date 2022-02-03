# php7.4-alpine

## usage

```dockerfile
FROM hetao29/php7.4-alpine
WORKDIR /data/www/

COPY index.php ./

```

## nginx
1. nginx

## extension
1. imap mbstring ldap redis mcrypt ldap mysql bcmath curl gd iconv openssl imagick zip ftp pcntl sockets exif
2. grpc swoole

## dir
### site root
```bash
/data/www/www
```

### php config
```bash
/etc/php7/php.ini
```

### php-fpm config
```bash
/etc/php7/php-fpm.conf 
/etc/php7/php-fpm.d/www.conf
```
### nginx config
```bash
/etc/nginx/nginx.conf
/etc/nginx/sites-enabled/www
```
