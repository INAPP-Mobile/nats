# NATS Server — single Go binary, JetStream on a persistent volume.
FROM nats:2-alpine

# Create /data (JetStream store dir; the base image already runs as root,
# so the root-owned Railway volume is writable here).
RUN mkdir -p /data

# Bake the JetStream-enabled server config into the image (a bind-mounted conf
# would break under rootless containers, so it lives in the image).
COPY nats-server.conf /etc/nats/nats-server.conf

# 4222 NATS client, 8222 monitor/health, 6222 cluster (reserved)
EXPOSE 4222 6222 8222

# In-container health check: monitor root page returns 200 when the server is up.
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=5 \
  CMD busybox wget -q -O /dev/null http://127.0.0.1:8222/ || exit 1

# Keep the base ENTRYPOINT (docker-entrypoint.sh) intact; override CMD to run
# the baked JetStream config. The entrypoint auto-prefixes `nats-server`.
CMD ["--config", "/etc/nats/nats-server.conf"]
