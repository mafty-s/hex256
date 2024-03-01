docker run \
  --platform linux/amd64 \
  -e RPC_HTTP_URL=http://host.docker.internal:8545 \
  -e DATABASE_URL=postgres://host.docker.internal/postgres \
  -p 3001:3001  \
  ghcr.io/latticexyz/store-indexer:latest  \
  pnpm start:postgres