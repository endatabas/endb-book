# Clients

Endatabas provides a variety of tools to communicate with an
Endb instance.

The Console is a command-line user interface to send
SQL to Endb manually.
The client libraries are used in the data access layer
of an application which uses Endb for storage.

The client libraries support both HTTP and WebSocket APIs.
To access Endb over HTTP, create an `Endb` instance
and call the `sql` method on it.
To access Endb over WebSockets, create an `EndbWebSocket`
instance and call the `sql` method on it.
See the language-specific documentation below for further details.

- [Console](./console.md)
- [JavaScript / TypeScript](./javascript.md)
- [Python](./python.md)

NOTE: For any programming language not listed above, it is possible
to create small client libraries such as these using the
[HTTP](../reference/http_api.md) and [WebSocket](../reference/websocket_api.md) APIs.
All official Endatabas clients are permissively-licensed and you are
welcome to use them as examples to create your own client library.
Their source code is available here:
[https://github.com/endatabas/endb/tree/main/clients](https://github.com/endatabas/endb/tree/main/clients)
