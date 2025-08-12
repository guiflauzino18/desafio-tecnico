FROM nginx:alpine

COPY index.html /usr/share/nginx/html

COPY build/nginx.conf /etc/nginx/conf.d/default.conf

RUN ["chmod", "777", "/etc/nginx/conf.d/default.conf"]