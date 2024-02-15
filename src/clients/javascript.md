
# JavaScript

The JavaScript client library is used to communicate with an Endb instance from
a JavaScript or TypeScript application.

[NPM Package: `@endatabas/endb`](https://www.npmjs.com/package/@endatabas/endb)

## Table of Contents

* [Install](#install)
* [Usage Examples](#usage-examples)
    * [Import](#import)
    * [Endb](#endb)
    * [EndbWebSocket](#endbwebsocket)
    * [sql()](#sql)
    * [Template Literals](#template-literals)
* [Data Types](#data-types)
* [Complete Examples](#complete-examples)
* [JavaScript API Reference](#javascript-api-reference)

## Install

```sh
npm install @endatabas/endb
npm install ws
```

## Usage Examples

### Import

```javascript
import { Endb, EndbWebSocket } from '@endatabas/endb';
```

### Endb

Use the `Endb` class to communicate with Endb over HTTP.
It accepts an optional `url` parameter.
Options can be supplied for `accept`, `username`, and `password`.
Accept headers default to LD-JSON and can be set to any valid
content type listed in the [HTTP API](../reference/http_api.md#accept-headers).
If you choose `application/vnd.apache.arrow.file` or `application/vnd.apache.arrow.stream`,
the raw response body will be be returned from `sql()`.

```javascript
var e = new Endb();
var e = new Endb('http://localhost:3803/sql');
var e = new Endb('http://localhost:3803/sql', {accept: 'text/csv'});
var e = new Endb('http://localhost:3803/sql', {accept: 'application/json', username: 'zig', password: 'zag'});
```

NOTE: Choosing accept headers other than LD-JSON will return
JavaScript data structures symmetrical with those returned from
the respective accept header provided to the HTTP API.
`text/csv` returns comma-delimited strings, `application/json`
returns tuples as arrays, and so on.

### EndbWebSocket

Use the `EndbWebSocket` class to communicate with Endb over WebSockets.
It accepts an optional `url` parameter.
Options can be supplied for `ws` (any implementation of the
[JavaScript WebSocket interface definition](https://websockets.spec.whatwg.org/#the-websocket-interface)),
`username`, and `password`.
In a web browser, `ws` will default to the web browser's WebSocket implementation.
`EndbWebSocket` only communicates in LD-JSON, so the accept header cannot be set.

```javascript
// in web browser:
var ews = new EndbWebSocket();
var ews = new EndbWebSocket('ws://localhost:3803/sql', {username: 'zig', password: 'zag'});

// in node.js:
import WebSocket from 'ws';
var ews = new EndbWebSocket({ws: WebSocket});
var ews = new EndbWebSocket('ws://localhost:3803/sql', {ws: WebSocket, username: 'zig', password: 'zag'});
```

### sql()

The asynchronous `sql` method is available to both `Endb` and `EndbWebSocket`.
It accepts `q`, and optional `p`, `m`, and `accept` parameters
and returns an array of strongly-typed documents.
(See [JavaScript API Reference](#javascript-api-reference).)

To ignore the `p` or `m` parameters but still supply an accept header,
supply the default values or `null`.

```javascript
e.sql("SELECT * FROM users;");
e.sql("INSERT INTO USERS (date, name, email) VALUES (?, ?, ?);", [new Date(), 'Aaron', 'aaron@canadahealth.ca']);
e.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], true);
e.sql("SELECT * FROM users;", [], false, 'text/csv');
e.sql("SELECT * FROM users;", null, null, 'application/json');
e.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], true, 'text/csv');
```

### Template Literals

It is possible to use [Template Literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)
(string templating) to pass named SQL parameters.
The parameter passed to the Template Literal is only valid
when used in a position where a [positional SQL parameter](../reference/http_api.md#positional-parameters)
is also valid.
The signature which accepts Template Literals does
not accept any other parameters to the method.

```javascript
var n = 'Michael';
e.sql`INSERT INTO users (name) VALUES (${n});`;

var u = {name: 'Radha', roles: ['artist', 'marketing']};
e.sql`INSERT INTO users objects ${u}`;
```

## Data Types

When an LD-JSON (default) accept header is used, strongly typed data is returned according to this mapping:

* `null` - `null`
* `xsd:date` - `Date`
* `xsd:dateTime` - `Date`
* `xsd:base64Binary` - `Uint8Array`
* `xsd:integer` - `BigInt`

For more information on Endb data types, see the
[Data Types doc](../reference/data_types.md).

## Complete Examples

```javascript
import { Endb } from '@endatabas/endb';

var e = new Endb();
await e.sql("INSERT INTO users {name: 'Thupil'};");
var result = await e.sql("SELECT * FROM users;");
console.log(result);

var e2 = new Endb('http://localhost:3803/sql', {accept: 'application/json', username: 'zig', password: 'zag'});
await e.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], true, 'text/csv');
result = await e.sql("SELECT * FROM users;", null, null, 'application/json');
console.log(result);
```

```javascript
import WebSocket from 'ws';
import { EndbWebSocket } from '@endatabas/endb';

var ews = new EndbWebSocket({ws: WebSocket});
await ews.sql("insert into users {name: 'Lydia'};");
var ws_result = await ews.sql("select * from users;");
console.log(ws_result);

var ews2 = new EndbWebSocket({ws: WebSocket, username: 'zig', password: 'zag'});
await ews2.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], true, 'text/csv');
ws_result = await ews2.sql("SELECT * FROM users;", null, null, 'application/json');
console.log(ws_result);
```

## JavaScript API Reference

NOTE: The following API documentation is generated from source code docstrings in the
[`endb` repository](https://github.com/endatabas/endb/tree/main/clients/javascript).

{{#include jsdoc.md}}
