FROM caddy:2-builder@sha256:d77a8c16fa27ac2ca567b3952480dd1bb21133fb543f7ad38d8e6b389c786d72 AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:c448cd56ef79160bb0514e10318e4a60f02e5ea141b7ac9f633364941ab56e92

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
