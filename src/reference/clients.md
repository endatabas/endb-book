# Clients

Official native clients are listed on this page.
For other programming languages, it is possible to create
small client libraries such as these using the
[HTTP](http_api.md) and [WebSocket](websocket_api.md) APIs.

## JavaScript

[NPM Package: `@endatabas/endb`](https://www.npmjs.com/package/@endatabas/endb)

### Install

```sh
npm install @endatabas/endb
npm install ws
```

### Usage

The client supports both HTTP and WebSocket APIs.

To access Endb over HTTP, create an `Endb` instance
and call the `sql` method on it.
To access Endb over WebSockets, create an `EndbWebSocket`
instance and call the `sql` method on it.

**Endb(url = 'http://localhost:3803/sql', {accept = 'application/ld+json', username, password})**

Used to communicate with Endb over HTTP.
Accept headers default to LD-JSON and can be set to any valid
content type listed in the [HTTP API](http_api.md).

**EndbWebSocket(url = 'ws://localhost:3803/sql', {ws, username, password})**

Used to communicate with Endb over WebSockets.
`EndbWebSocket` only communicates in LD-JSON.

**sql(query, ...params)**

The `sql` method is available to both `Endb` and `EndbWebSocket`.
This asynchronous method returns an array of strongly-typed documents.

**Examples**

```javascript
import WebSocket from 'ws';
import { Endb, EndbWebSocket } from '@endatabas/endb';

var e = new Endb();
await e.sql("insert into users {name: 'Thupil'};");
var result = await e.sql("select * from users;");
console.log(result);

var ews = new EndbWebSocket({ws: WebSocket});
await ews.sql("insert into users {name: 'Lydia'};");
var ws_result = await ews.sql("select * from users;");
console.log(ws_result);
```

It is possible to use string templating to pass named parameters:

```javascript
ews.sql(`select * from ${t}`, {t: 'users'});
```
