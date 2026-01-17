FROM kong:2.8.1
COPY ./kong.yml /home/kong/temp.yml
USER 0
RUN apk update && apk add gettext ca-certificates bind-tools curl && update-ca-certificates
USER kong
ENTRYPOINT bash -c 'envsubst < ~/temp.yml > ~/kong.yml && /docker-entrypoint.sh kong docker-start'
