FROM caddy:2-builder@sha256:ea6e54f62d2033b80747b022923ae0dd4f817ec4eefa2ca3a34cbebf16b6468c AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:af5fdcd76f2db5e4e974ee92f96ee8c0fc3edb55bd4ba5032547cbf3f65e486d

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
