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

## Example Libraries

Ultimately, Endb will ship with permissively-licensed client libraries for all major languages.
For now, we have provided some example code you can try:

[https://github.com/endatabas/endb/tree/main/examples](https://github.com/endatabas/endb/tree/main/examples)

## Example Console

Endb does not yet provide an official SQL console.
However, you can try Endb SQL (without writing any code) with the example terminal:

```sh
git clone git@github.com:endatabas/endb.git
cd endb/examples
./endb_console.py
```

This example console wraps the Python example library.
Assuming you inserted a user with curl above, you can query that table directly:

```sh
-> SELECT * FROM users;
```

You can use any of these tools (or any other HTTP client you prefer) for the rest of this tutorial.
