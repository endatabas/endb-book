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

You can use the [Console](../clients/console.md):

```sh
$ pip install endb
$ endb_console
-> SELECT 'Hello World';
```

...or you can send queries to the API directly:

```sh
curl -d "SELECT 'Hello World';" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

{{#include ../alpha-warning.md}}
