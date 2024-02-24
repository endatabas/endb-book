# Quickstart

## Install Endb

```sh
mkdir -p endb_data
docker pull endatabas/endb
docker run --rm -p 3803:3803 -v endb_data:/app/endb_data docker.io/endatabas/endb
```

See [Installation](../reference/installation.md) for more ways to install
and build `endb`.

See [Try It!](try_it.md) for methods of connecting to Endb and running queries.

## Try Online

If you do not want to install a full Endb instance, you can try the
[Wasm Console](https://endatabas.com/console.html) instead.

The Wasm Console runs Endb directly in your web browser,
so you can ignore the steps in [Try It!](try_it.md) and jump straight to
[Endb SQL Basics](sql_basics.md).

NOTE: The Wasm Console is not a full Endb instance.
It does not provide APIs and has other performance
and infrastructure limitations.
