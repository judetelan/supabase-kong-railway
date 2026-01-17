FROM caddy:2.7-alpine

COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 8080

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
