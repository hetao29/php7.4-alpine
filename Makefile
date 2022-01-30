build:
	docker build . -t hetao29/php7.4-alpine:latest
push:
	docker tag hetao29/php7.4-alpine:latest hetao29/php7.4-alpine:1.0.0
	docker push -a hetao29/php7.4-alpine
test:
	docker run -p 8881:80 hetao29/php7.4-alpine:latest
