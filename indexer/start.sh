docker run \
   --platform linux/amd64 \
   -e RPC_HTTP_URL=192.168.31.29:8545 \
   -e SQLITE_FILENAME=/dbase/anvil.db \
   -v sqlite-db-file:/dbase \
   -p 3001:3001  \
   ghcr.io/latticexyz/store-indexer:latest  \
   pnpm start:sqlite