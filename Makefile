build:
	docker build . -t hetao29/php7.4-alpine:1.0.0
push:
	docker push hetao29/php7.4-alpine:1.0.0
test:
	docker run -p 8881:80 hetao29/php7.4-alpine:1.0.0
