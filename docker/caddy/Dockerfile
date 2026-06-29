FROM caddy:2-builder@sha256:26f5271c26850df54ef7a9f3704b5d688c1ad51b5cde509c9d011b4e95cc8397 AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:1557580dffd3f309e30bd76b23a26aa3970d98bff11313cfa3a63b735ac8d04a

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
