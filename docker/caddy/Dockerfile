FROM caddy:2-builder@sha256:ffa8572dfe784332cce850b255926465b5a71c947af60e6b4b17bf6adca4fedb AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:af5fdcd76f2db5e4e974ee92f96ee8c0fc3edb55bd4ba5032547cbf3f65e486d

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
