FROM nginx:1.15

COPY /build/web/ /usr/share/nginx/html

COPY /nginx.conf /etc/nginx/conf.d/default.conf