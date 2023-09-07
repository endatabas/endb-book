# Quickstart

## Install Endb

```sh
mkdir -p endb_data
docker pull endatabas/endb
docker run --rm -p 3803:3803 -v endb_data:/app/endb_data docker.io/endatabas/endb
```

See [Installation](../reference/installation.md) for more ways to install
and build `endb`.

## Run your first query

```sh
curl -d "SELECT 'Hello World';" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

{{#include ../alpha-warning.md}}
