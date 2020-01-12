FROM nginx:1.10.3-alpine

RUN rm -f /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/
EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
