FROM nginx:1.19-alpine AS builder


RUN apk add --no-cache --update

RUN apk add --no-cache --update \
	npm \
	bash \ 
	git \
	curl \ 
	vim \ 
	openssh

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./site-enable /etc/nginx/conf.d
RUN rm /etc/nginx/conf.d/default.conf

COPY ./shaft-fe/backoffice /home/shaft/shaft-fe/backoffice
COPY ./shaft-fe/service /home/shaft/shaft-fe/service

WORKDIR /home/shaft/shaft-fe/

COPY ./shell/front.run.sh /usr/local/bin/front.run.sh
RUN sed -i -e 's/\r$//' /usr/local/bin/front.run.sh && \
	chmod 0777 /usr/local/bin/front.run.sh

ENTRYPOINT [ "/bin/bash", "/usr/local/bin/front.run.sh" ]