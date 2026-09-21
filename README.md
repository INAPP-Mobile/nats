# NATS Server — Lightstream Messaging with JetStream

Deploy [NATS Server](https://github.com/nats-io/nats-server) (18k+ stars) — a fast, ultra-low-latency messaging platform — as a lightweight, single-container service with JetStream (durable, file-backed persistence) on a Railway volume.

## Deploy and Host

Host your own NATS messaging server on Railway. This template provisions the NATS server with JetStream enabled and a persistent volume for durable streams, consumers, and stored messages.

[![Deploy to Railway](https://railway.app/button.svg)](https://railway.com/deploy/nats-1)

## Why Deploy

NATS is the lightweight messaging core behind event-driven microservices, edge deployments, and IoT fleets. Running it on Railway gives you an always-on, auto-updating, globally reachable message broker with:

- **Ultra-low latency core** — classic async pub/sub + request/reply, single Go binary, ~40–80 MB RAM (Hobby-plan friendly)
- **JetStream persistence** — durable streams, consumers, and replayable history on a Railway volume (survives restarts and redeploys)
- **Single container** — no database, no external dependencies
- **Instant health** — HTTP `200` on the monitor port for Railway health checks and status endpoints
- **Minimal footprint** — ~29 MB image

## Common Use Cases

- **Message queues for microservices** — decouple services with durable pub/sub
- **Event streaming** — durable streams with consumer groups and replay
- **Request/reply** — low-latency RPC over a message bus
- **Edge / IoT fan-out** — lightweight broker far from heavy MQs
- **Service discovery** — NATS-based service registration

### Deployment Dependencies

The deploy form pre-fills all required variables. No companion services needed — NATS runs as a single container with one volume for JetStream persistence.

**After the first successful deploy:**

1. Open your public domain → monitor port to hit the health / status endpoints (instant `200`).
2. Connect clients on NATS clients via the private domain: port `4222`.
3. Durable state (streams, consumers, messages) persists on the `/data` volume.

## About Hosting

NATS runs as a single container on Railway with a volume mount at `/data`. JetStream state — streams, consumers, and messages — is file-backed under `/data/jetstream` and survives restarts and redeploys. The server starts as root (the base image default) so the root-owned volume is writable.

### Ports & Health

| Port | Purpose | Reach |
|------|---------|-------|
| `4222` | NATS client protocol | private domain |
| `8222` | Monitor / HTTP API (health) | public domain (health = `GET /` returns `200`) |
| `6222` | Cluster (reserved) | private (reserved for future multi-node) |

## Dependencies for

This template deploys a single NATS container with a Railway volume for JetStream persistence. No additional services are required.

## Configuration

The JetStream-enabled server config is baked into the image (a bind-mounted config would break under rootless containers). JetStream data is stored under `/data`, which is mounted from the Railway volume.

Optional environment variable overrides are listed in `.env.example`.

## Notes

- This is a single-node, single-container deployment. Multi-node clustering (port `6222`) is reserved and can be added as additional services in the same project.
- Always-on messaging is intentionally "sticky" — keep the service running to retain durable state.
