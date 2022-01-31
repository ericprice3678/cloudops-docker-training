FROM nginx:latest

RUN apt-get update

ADD nginx.conf /etc/nginx/conf.d/default.conf

ADD index.html /usr/share/nginx/index.html

CMD ["nginx", "-g", "daemon off;"]