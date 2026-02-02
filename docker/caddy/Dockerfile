FROM caddy:2-builder@sha256:b6424b4a90e25fde5cb9fd8e1da716159a313869ac3ba1c34b11c50781acab81 AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:f20f80e1fb627294fb84b8515b7593aff8018c840f1396dc942a50ed0c2db648

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
