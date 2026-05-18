FROM caddy:2-builder@sha256:1ecefa333507828a592aaecc68d5f62a993787057429c04e9b0438a65c980a30 AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:ec18ee54aab3315c22e25f3b2babda73ff8007d39b13b3bd1bfffa2f0444c7d9

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
