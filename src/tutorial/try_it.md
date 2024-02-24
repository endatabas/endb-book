# Try It!

You can send SQL statements to `endb` over HTTP or WebSockets.
Any HTTP or WebSocket client will do, and Endb ships with a console
and client libraries.

## curl

Our first couple examples will use [curl](https://everything.curl.dev/install),
which you probably already have installed, to send queries directly to the API.

```sh
curl -d "INSERT INTO users (name) VALUES ('Tianyu')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "SELECT * FROM users" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

You don't need to use the API diretly if there is a client library available for
your language of choice, but it is helpful to know that the underlying API is
human-readable and based on open standards.
Read more in the [full HTTP API docs](../reference/http_api.md).

## Console

Endb provides a small console for writing Endb SQL directly:

```sh
pip install endb_console
endb_console # connects to localhost by default
```

Assuming you inserted a user with curl above, you can query that table directly:

```sh
-> SELECT * FROM users;
```

Read more in the [Console doc](../clients/console.md).

## Client Libraries

Endb ships with permissively-licensed (MIT) client libraries:

```sh
pip install endb
npm install @endatabas/endb
```

You can copy and modify their
[source code](https://github.com/endatabas/endb/tree/main/clients)
for any purpose.
Read more about how to use them in the [client libraries docs](../clients/).

## Learning Endb SQL

You can use any of these tools (or any other HTTP client you prefer) for the rest of this tutorial.
