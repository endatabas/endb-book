# Try It!

You can send SQL statements to `endb` over HTTP.
Any HTTP client will do.

## curl

Our first couple examples will use [curl](https://everything.curl.dev/get),
which you probably already have installed.

```sh
curl -d "INSERT INTO users (name) VALUES ('Tianyu')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "SELECT * FROM users" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

Read more in the [full HTTP API docs](../reference/http_api.md).

## Client Libraries

Endb ships with permissively-licensed client libraries:

[https://github.com/endatabas/endb/tree/main/clients](https://github.com/endatabas/endb/tree/main/clients)

## Console

Endb provides a small console for writing Endb SQL directly:

```sh
git clone git@github.com:endatabas/endb.git
cd endb/clients
./endb_console.py
```

This console wraps the Python library.
Assuming you inserted a user with curl above, you can query that table directly:

```sh
-> SELECT * FROM users;
```

You can use any of these tools (or any other HTTP client you prefer) for the rest of this tutorial.
