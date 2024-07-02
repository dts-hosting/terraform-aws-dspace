FROM --platform=linux/amd64 nginx

COPY templates/*-domain.conf.template /etc/nginx/conf.d/

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
