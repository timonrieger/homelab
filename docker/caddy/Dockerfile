FROM caddy:2-builder@sha256:01668408cc26e2e00c9d067c30cb43b2ba14ad1f2808beda55503cb2a31f59dc AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:c448cd56ef79160bb0514e10318e4a60f02e5ea141b7ac9f633364941ab56e92

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
