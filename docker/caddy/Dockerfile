FROM caddy:2-builder@sha256:9780b126deae015b2c262fa9f4f1f951577e1f6a5fe4d88c0573aeb622071b2d AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:c448cd56ef79160bb0514e10318e4a60f02e5ea141b7ac9f633364941ab56e92

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
