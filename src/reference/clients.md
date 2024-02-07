# Clients

Official native clients are listed on this page.

* [JavaScript](#javascript)
* [Python](#python)

For other programming languages, it is possible to create
small client libraries such as these using the
[HTTP](http_api.md) and [WebSocket](websocket_api.md) APIs.

The clients supports both HTTP and WebSocket APIs.
To access Endb over HTTP, create an `Endb` instance
and call the `sql` method on it.
To access Endb over WebSockets, create an `EndbWebSocket`
instance and call the `sql` method on it.

## JavaScript

[NPM Package: `@endatabas/endb`](https://www.npmjs.com/package/@endatabas/endb)

### Install

```sh
npm install @endatabas/endb
npm install ws
```

### Usage

**Import**

```javascript
import { Endb, EndbWebSocket } from '@endatabas/endb';
```

**Endb**

Use the `Endb` class to communicate with Endb over HTTP.
It accepts an optional `url` parameter.
Options can be supplied for `accept`, `username`, and `password`.
Accept headers default to LD-JSON and can be set to any valid
content type listed in the [HTTP API](http_api.md#accept-headers).

```javascript
var e = new Endb();
var e = new Endb('http://localhost:3803/sql');
var e = new Endb('http://localhost:3803/sql', {accept: 'application/csv'});
var e = new Endb('http://localhost:3803/sql', {accept: 'application/json', username: 'zig', password: 'zag'});
```

**EndbWebSocket**

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
var ews = new EndbWebSocket({username: 'zig', password: 'zag'});

// in node.js:
import WebSocket from 'ws';
var ews = new EndbWebSocket({ws: WebSocket});
var ews = new EndbWebSocket({ws: WebSocket, username: 'zig', password: 'zag'});
```

**sql()**

* Method Signature: `sql(query, p, m, accept)`
    * `p`: array of SQL parameters (default: `[]`)
    * `m`: many flag (default: `false`)
    * `accept`: accept header content type (default: `application/ld+json`)

The `sql` method is available to both `Endb` and `EndbWebSocket`.
This asynchronous method returns an array of strongly-typed documents.
To ignore the `p` or `m` parameters and supply an accept header,
supply the default values or `null`.

```javascript
e.sql("INSERT INTO USERS (date, name, email) VALUES (?, ?, ?);", [new Date(), 'Aaron', 'aaron@canadahealth.ca']);
e.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], true);
e.sql("SELECT * FROM users;", [], false, 'text/csv');
e.sql("SELECT * FROM users;", null, null, 'application/json');
e.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], true, 'text/csv');
```

It is possible to use string templating to pass named SQL parameters.
String templating does not accept any other parameters to the method:

```javascript
e.sql(`SELECT * FROM ${t}`, {t: 'users'});
```

**Data Types**

When an LD-JSON (default) accept header is used, strongly typed data is returned according to this mapping:

* `null` - `null`
* `xsd:date` - `Date`
* `xsd:dateTime` - `Date`
* `xsd:base64Binary` - `Uint8Array`
* `xsd:integer` - `BigInt`

For more information on Endb data types, see the [Data Types doc](data_types.md).

**Complete Examples**

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

## Python

[PyPI Package: `endb`](https://pypi.org/project/endb/)

### Install

```sh
pip install endb
pip install websockets
```

### Usage

**Endb(self, url='http://localhost:3803/sql', accept='application/ld+json', username=None, password=None)**

Used to communicate with Endb over HTTP.
Accept headers default to LD-JSON and can be set to any valid
content type listed in the [HTTP API](http_api.md).

**EndbWebSocket(self, url='ws://localhost:3803/sql', username=None, password=None)**

Used to communicate with Endb over WebSockets.
`EndbWebSocket` only communicates in LD-JSON.

**sql(self, q, p=[], m=False, accept=None)**

The `sql` method is available to both `Endb` and `EndbWebSocket`.
This method returns an array of strongly-typed documents.
`sql`is synchronous for `Endb` and asynchronous for `EndbWebSocket`.

**Examples**

```python
from endb import Endb
e = Endb()
e.sql("INSERT INTO users {name: 'Yuvi'}")
e.sql("SELECT * FROM users;")
```

When the `websockets` dependency is installed, it is possible to
return asynchronous results to the Python interactive shell
directly if you start it with `python3 -m asyncio`:

```python
from endb import EndbWebSocket
ews = EndbWebSocket()
result = await ews.sql("SELECT * FROM users;")
print(result)
```
