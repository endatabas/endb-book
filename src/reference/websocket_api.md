# WebSocket API

If a [client](../clients/) is
not available for your programming language yet, your app can interact
directly with the Endb WebSocket API.
Any WebSocket client can be used but in the examples below we'll use
[`websocat`](https://github.com/vi/websocat#installation) to demonstrate
the API without writing any code.
Connect to Endb with:

```sh
websocat ws://localhost:3803/sql
```

You can send SQL statements to `endb` over
[WebSockets](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API)
with [JSON-RPC 2.0](https://www.jsonrpc.org/specification).

```json
{"jsonrpc": "2.0", "id": 1, "method": "sql", "params": {"q": "INSERT INTO users (name) VALUES (?);", "p": [["Tsehay"], ["Iniku"]], "m": true}}
{"jsonrpc": "2.0", "id": 2, "method": "sql", "params": {"q": "SELECT * FROM users;", "p": [], "m": false}}
```

NOTE: To send the method calls above, paste them into a `websocat`
session one-at-a-time and press `<enter>`.
Further examples will assume JSON-RPC strings are sent in an existing
`websocat` session.

## JSON-RPC Request Object

Following the JSON-RPC 2.0 spec, a SQL statement or query
to the Endb WebSocket API requires these components:

* `id` - a string or integer identifier used to correlate requests to responses
* `method` - always the string `"sql"`
* `params` - request params are sent as JSON-RPC by-name request parameters, as listed below

### JSON-RPC Request Parameters

* `q` - (q)uery: a SQL query, optionally parameterized
* `p` - (p)arameters: named or positional SQL [parameters](websocket_api.md#parameters)
* `m` - (m)any parameter lists: [bulk parameters](websocket_api.md#bulk-parameters), used for bulk insert/update

## JSON-RPC Response Object

A response from the Endb WebSocket API will include these components:

* `id` - the id provided in the request object, so it can be correlated
* `result` - the response, encoded as JSON-LD, as in this example:

```json
{"jsonrpc":"2.0", "id":111, "result":{"@context":{"xsd":"http://www.w3.org/2001/XMLSchema#","@vocab":"http://endb.io/"},"@graph":[{"name":"Hing","price":2.99}]}}
```

If your query is invalid or causes an internal error, you will receive
an error instead, which includes:

* `id` - the id of the request object, if one was provided (otherwise `null`)
* `error` - a code and message, as returned by Endb

```json
{"jsonrpc":"2.0", "id":222, "error":{"code":-32603,"message":"Error: Unknown table: users\n   ╭─[<unknown>:1:15]\n   │\n 1 │ SELECT * FROM users;\n   │               ──┬──  \n   │                 ╰──── Unknown table\n───╯\n"}}
```

## WebSocket Basic Authentication

Endb supports HTTP Basic Authentication, as defined by
[RFC 7235](https://datatracker.ietf.org/doc/html/rfc7235), on top of
[RFC 6455](https://datatracker.ietf.org/doc/html/rfc6455.html).
This is because the WebSocket Protocol RFC (6455) does not define
authentication mechanisms itself.

Pass `--username` and `--password` arguments to the `endb` binary to force
basic authentication for HTTP connections.
(See [Operation](operation.md) for more details, including environment variables
which can be passed to Docker images.)

```sh
./target/endb --username zig --password zag
```

Then, use Basic Auth headers to connect to Endb:

```sh
websocat -H='Authorization: Basic' ws://zig:zag@localhost:3803/sql
```

Rather than `Authorization: Basic`, the `Sec-WebSocket-Protocol` header
may be used.
It is offered because web browsers do not support the Basic Auth
header over WebSockets.

## Parameters

SQL parameters to a WebSocket request are always [JSON-LD](https://json-ld.org/).
A JSON-LD scalar always has the form: `{"@type": "xsd:TYPE", "@value": "DATA"}`.
JSON-LD types are listed under the [Data Types](data_types.md) table.

For example, if a strongly-typed DateTime is required, it can be submitted like so:

```sh
{"jsonrpc": "2.0", "id": 11, "method": "sql", "params": {"q": "INSERT INTO users (name, date) VALUES (?, ?);", "p": ["dosha", {"@value": "2024-01-29T18:18:30.129159", "@type": "xsd:dateTime"}], "m": false}}
```

### Named Parameters

Named SQL parameters substitute parameter placeholders with the form `:param`
by the parameter key with the corresponding name.
Named parameters are represented as a JSON object.

```sh
{"jsonrpc": "2.0", "id": 111, "method": "sql", "params": {"q": "INSERT INTO products {name: :name, price: :price};", "p": {"name": "Hing", "price": 2.99}, "m": false}}
{"jsonrpc": "2.0", "id": 112, "method": "sql", "params": {"q": "INSERT INTO events {start: :start};", "p": {"start": {"@type": "xsd:dateTime", "@value": "2021-04-09T20:00:00Z"}}, "m": false}}
```

### Positional Parameters

Positional SQL parameters substitute parameter placeholders with the form `?`
by the parameter values, in the order they appear.
Positional parameters are respresented as a JSON array.

```sh
{"jsonrpc": "2.0", "id": 211, "method": "sql", "params": {"q": "SELECT * FROM products WHERE name = ? AND price > ?;", "p": ["Hing", 2.00], "m": false}}
{"jsonrpc": "2.0", "id": 213, "method": "sql", "params": {"q": "INSERT INTO events {start: ?};", "p": [{"@type": "xsd:dateTime", "@value": "2021-04-09T20:00:00Z"}], "m": false}}
```

### Bulk Parameters

Bulk operations are possible by setting the `m` flag to `true`.
Bulk operations are available to both named and positional parameters.
The list of parameters supplied in bulk must be nested in an array.

```sh
{"jsonrpc": "2.0", "id": 311, "method": "sql", "params": {"q": "INSERT INTO users {name: :name};", "p": [{"name": "Sungwon"}, {"name": "Olga"}], "m": true}}
{"jsonrpc": "2.0", "id": 312, "method": "sql", "params": {"q": "INSERT INTO sauces {name: ?, color: ?};", "p": [["Sriracha", "#FE6F5E"], ["Gochujang", "#FF8066"]], "m": true}}
```

## Transactions

Unlike the [HTTP API](http_api.md), the WebSocket API is stateful and thus
capable of explicit transactions.
See the [Transactions](../sql/queries.md#transactions) documentation for
further details on SQL syntax.

```sh
{"jsonrpc": "2.0", "id": 411, "method": "sql", "params": {"q": "BEGIN TRANSACTION;", "p": [], "m": false}}
{"jsonrpc": "2.0", "id": 412, "method": "sql", "params": {"q": "INSERT INTO delete_me {name: 'Roll Me Back'};", "p": [], "m": false}}
{"jsonrpc": "2.0", "id": 413, "method": "sql", "params": {"q": "ROLLBACK;", "p": [], "m": false}}
{"jsonrpc": "2.0", "id": 414, "method": "sql", "params": {"q": "SELECT * FROM delete_me;", "p": [], "m": false}}
```
