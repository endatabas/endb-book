# HTTP API

If a [client](https://github.com/endatabas/endb/tree/main/examples) is
not available for your programming language yet, your app can interact
directly with the Endb HTTP API.
Any HTTP client may be used but in the examples below we'll use `curl`
to demonstrate the API without writing any code.

You can send SQL statements to `endb` over HTTP:

```sh
curl -d "INSERT INTO users (name) VALUES ('Tianyu')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "SELECT * FROM users" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

You can send SQL to `endb` with standard HTTP Query Parameters, Verbs,
Content Types, Accept Headers, and HTTP Basic Authentication.
Each one is outlined below.

## HTTP Query Parameters

The query parameters Endb's HTTP endpoint accepts are:

* `q` - (q)uery: a SQL query, optionally parameterized
* `p` - (p)arameters: named or positional [parameters](http_api.md#parameters)
* `m` - (m)any parameter lists: [bulk parameters](http_api.md#bulk-parameters), used for bulk insert/update

## HTTP Verbs

`POST` allows explicit Content Types and Accept headers:

```sh
curl -d 'SELECT 1' -H "Content-Type: application/sql" -H "Accept: text/csv" -X POST http://localhost:3803/sql
```

`GET` allows a single, simple URL.
`GET` does not permit DML.

```sh
curl -X GET "http://localhost:3803/sql?q=SELECT%201"
```

## Content Types

The HTTP `Content-Type` header is used to specify what
format the client is sending data to Endb.

### `application/json`:

```sh
curl -d '{"q": "SELECT * from products;"}' -H "Content-Type: application/json" -X POST http://localhost:3803/sql
curl -d '{"q": "SELECT * from products WHERE name = ?;", "p": ["Salt"]}' -H "Content-Type: application/json" -X POST http://localhost:3803/sql
curl -d '{"q": "INSERT INTO products {name: :name};", "p": {"name": "Paprika"}}' -H "Content-Type: application/json" -X POST http://localhost:3803/sql
```

NOTE: To enable strongly-typed values, payloads sent with
the `application/json` content type have values resolved with JSON-LD scalars.
Standard JSON values are a subset of JSON-LD scalars, so data sent as regular
JSON is unaffected by this behaviour.

### `application/ld+json`

Although values in the `application/json` content type are resolved using
JSON-LD scalars, you can explicitly specify an `application/ld+json`
content type to avoid all ambiguity.
See [JSON-LD](https://json-ld.org/).

```sh
curl -d '{"q": "INSERT INTO events {start: :start};", "p": {"start": {"@type": "xsd:dateTime", "@value": "2011-04-09T20:00:00Z"}}}' -H "Content-Type: application/ld+json" -X POST http://localhost:3803/sql
```

### `application/sql`:

```sh
curl -d 'SELECT 1' -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

Submit parameters to `application/sql` by providing form data or query parameters.
Form data and query parameters can be combined, though it is not necessarily recommended.

```sql
curl -F q="INSERT INTO sauces {name: ?, color: ?};" -X POST http://localhost:3803/sql?p=%5B%22ketchup%22%2C%22purple%22%5D
```

### `multipart/form-data`

```sh
curl -F q="SELECT * from products;" -H "Content-Type: multipart/form-data" -X POST http://localhost:3803/sql
curl -F q="INSERT INTO products {name: ?};" -F p='["Sriracha"]' -X POST http://localhost:3803/sql
```

NOTE: Many HTTP clients (including `curl`) automatically assume a content type of
`multipart/form-data` when form fields are provided.
This is true for `curl` when the `-F` (`--form`) argument is used and it has
been elided from further examples.

### `application/x-www-form-urlencoded`

Although the other content types are preferable for obvious reasons,
`application/x-www-form-urlencoded` is offered for completeness.

```sh
curl -d 'q=SELECT%20*%20FROM%20products;' -H "Content-Type: application/x-www-form-urlencoded" -X POST http://localhost:3803/sql
```

## Accept Headers

The HTTP `Accept` header is used to specify how data is returned to
the Endb client.
The default `Accept` header content type is `application/json`.

### text/csv

`text/csv` returns comma-separated rows.
Column order from the `SELECT` clause is maintained.

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,'csv')) t1" -H "Content-Type: application/sql" -H "Accept: text/csv" -X POST http://localhost:3803/sql
```

returns:

```
"column1","column2"
2,"csv"
1,"hello"
```

### application/json

`application/json` returns rows as an array of JSON tuples.
Column order from the `SELECT` clause is maintained.

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,DATE('2023-07-22'))) t1" -H "Content-Type: application/sql" -H "Accept: application/json" -X POST http://localhost:3803/sql
```

returns:

```
[[2,"2023-07-22"],[1,"hello"]]
```


### application/x-ndjson

`application/x-ndjson` returns newline-delimited JSON documents.
Column order from the `SELECT` clause is _not_ maintained.
JSON documents cannot guarantee column order.

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,DATE('2023-07-22'))) t1" -H "Content-Type: application/sql" -H "Accept: application/x-ndjson" -X POST http://localhost:3803/sql
```

returns:

```json
{"column1":2,"column2":"2023-07-22"}
{"column1":1,"column2":"hello"}
```

### application/ld+json

`application/ld+json` returns documents of strongly-typed ("Linking Data") JSON records.
Column order from the `SELECT` clause is _not_ maintained.
JSON documents cannot guarantee column order.

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,DATE('2023-07-22'))) t1" -H "Content-Type: application/sql" -H "Accept: application/ld+json" -X POST http://localhost:3803/sql
```

returns:

```json
{"@context":{"xsd":"http://www.w3.org/2001/XMLSchema#","@vocab":"http://endb.io/"},"@graph":[{"column1":2,"column2":{"@value":"2023-07-22","@type":"xsd:date"}},{"column1":1,"column2":"hello"}]}
```

See [JSON-LD](https://json-ld.org/).

### application/vnd.apache.arrow.file

`application/vnd.apache.arrow.file` returns columnar data as an Apache Arrow file.

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,DATE('2023-07-22'))) t1" -H "Content-Type: application/sql" -H "Accept: application/vnd.apache.arrow.file" -X POST http://localhost:3803/sql --output hello.arrow
```

The above command returns a file containing a single `RecordBatch` in an Apache Arrow file in IPC format.
You can examine the file with functions like
[`pyarrow.ipc.open_file`](https://arrow.apache.org/docs/python/ipc.html#writing-and-reading-random-access-files),
as seen in [this gist](https://gist.github.com/deobald/a65ca0f57d66041bf66d41d0509a981f).

### application/vnd.apache.arrow.stream

`application/vnd.apache.arrow.stream` returns columnar data as an Apache Arrow stream.

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,DATE('2023-07-22'))) t1" -H "Content-Type: application/sql" -H "Accept: application/vnd.apache.arrow.stream" -X POST http://localhost:3803/sql --output streamed.arrow
```

The above command returns a file containing an Apache Arrow IPC stream.
You can examine the file with functions like
[`pyarrow.ipc.open_stream`](https://arrow.apache.org/docs/python/ipc.html#using-streams),
as seen in [this gist](https://gist.github.com/deobald/1eeca3a08ca1490f49bb67a0fa31994b).


## HTTP Basic Authentication

Endb supports HTTP Basic Authentication as defined by
[RFC 7235](https://datatracker.ietf.org/doc/html/rfc7235).
Pass `--username` and `--password` arguments to the `endb` binary to force
basic authentication for HTTP connections.

```sh
./target/endb --username zig --password zag
```

Then, from any HTTP client, provide the username and password combination to
execute queries.

```sh
curl --user zig:zag -d "SELECT 'Hello World';" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

If the client passes an incorrect username or password, it will receive a
`401 Authorization Required` HTTP status code as a result, but no body.
Be aware of this to ensure client code is written to detect 401 status codes.

```sh
$ curl -i --user zig:wrong -d "SELECT 'Hello World';" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
HTTP/1.1 401 Authorization Required
```

## Parameters

SQL parameters are available to:

* `application/json` and `application/ld+json` as part of the `POST` body
* `multipart/form-data` as form data
* `application/x-www-form-urlencoded` as URL query parameters
* `application/sql` as form data and/or URL query parameters

Parameters can be JSON literals, JSON-LD scalars, or SQL literals.
A JSON-LD scalar always has the form: `{"@type": "xsd:TYPE", "@value": "DATA"}`.
JSON-LD types are listed under the [Data Types](data_types.md) table.

### Named Parameters

Named parameters substitute parameter placeholders with the form `:param`
by the parameter key with the corresponding name.
Named parameters are represented as a JSON object.

```sh
curl -d '{"q": "INSERT INTO products {name: :name, price: :price};", "p": {"name": "Paprika", "price": 2.99}}' -H "Content-Type: application/json" -X POST http://localhost:3803/sql
curl -d '{"q": "INSERT INTO events {start: :start};", "p": {"start": {"@type": "xsd:dateTime", "@value": "2011-04-09T20:00:00Z"}}}' -H "Content-Type: application/ld+json" -X POST http://localhost:3803/sql
curl -F q="INSERT INTO products {name: :sauce};" -F p='{"sauce": "Sriracha"}' -X POST http://localhost:3803/sql
```

### Positional Parameters

Positional parameters substitute parameter placeholders with the form `?`
by the parameter values, in the order they appear.
Positional parameters are respresented as a JSON array.

```sh
curl -d '{"q": "SELECT * FROM products WHERE name = ? AND price > ?;", "p": ["Salt", 3.99]}' -H "Content-Type: application/json" -X POST http://localhost:3803/sql
curl -d '{"q": "INSERT INTO events {start: ?};", "p": [{"@type": "xsd:dateTime", "@value": "2011-04-09T20:00:00Z"}]}' -H "Content-Type: application/ld+json" -X POST http://localhost:3803/sql
curl -F q="INSERT INTO products {name: ?};" -F p='["Sriracha"]' -X POST http://localhost:3803/sql
```

### Bulk Parameters

Bulk operations are possible by setting the `m` flag to `true`.
Bulk operations are available to both named and positional parameters.
The list of parameters supplied in bulk must be nested in an array.

```sh
curl -d '{"q": "INSERT INTO products {name: :name};", "p": [{"name": "Soda"}, {"name": "Tonic"}], "m": true}' -H "Content-Type: application/json" -X POST http://localhost:3803/sql
curl -F q="INSERT INTO sauces {name: ?, color: ?};" -F p='[["Mustard", "Yellow"], ["Ketchup", "Red"]]' -F m=true -X POST http://localhost:3803/sql
```

### Apache Arrow File Parameters

As it is possible to receive Apache Arrow data from an Endb query,
it is possible to submit Apache Arrow as a statement parameter.
The example below assumes the existence of a a table called `names`,
which only contains one column (`name`).
Apache Arrow Streams can also be used as parameters in the same way.

```sh
# create a sample Arrow file:
curl -d "SELECT * FROM names;" -H "Content-Type: application/sql" -H "Accept: application/vnd.apache.arrow.file" -X POST http://localhost:3803/sql --output names.arrow
# use the sample Arrow file:
curl -F m=true -F q="INSERT INTO projects {name: :name};" -F "p=@names.arrow;type=application/vnd.apache.arrow.file" -X POST http://localhost:3803/sql
```

NOTE: This feature should be used with caution.
Do not submit arbitrary Arrow files as parameters.
If a malformed Arrow file is submitted, the error message returned
(if any) is unlikely to provide guidance.
Preferably, Arrow files should be created using Endb itself, as in
the example above.
Most users will prefer to use a human-readable file format instead,
such as a JSON variant or static SQL statements.

## Bulk Insert

Bulk inserts are possible by combining the tools mentioned under [_Parameters_](#parameters).

For example, the [`OBJECTS`](../sql/queries.md#objects-lists) keyword can insert an
array of object literals.
Note that each object used as a positional parameter must be wrapped in a JSON array,
since there may be more than one positional parameter supplied.
Similarly, each named parameter must be wrapped in an object containing a key of the
corresponding name.

```sql
curl -F m=true -F q="INSERT INTO products OBJECTS ?" -F p="[[{name: 'jam'}], [{name: 'butter'}]]" -X POST http://localhost:3803/sql
curl -F m=true -F q="INSERT INTO products OBJECTS :product" -F p="[{product: {name: 'jelly'}}, {product: {name: 'ghee'}}]" -X POST http://localhost:3803/sql
```


## Multiple Statements

It is possible to pass multiple SQL statements to Endb by delimiting
them with semicolons.
Parameters will be passed to all statements in order.

Only the result of the last statement is returned to the client.
In the following example, the `INSERT` will be successful but will not
return a result.
The `SELECT` will return to the client.

```sh
curl --form-string q="INSERT INTO sauces {name: ?, color: ?}; SELECT {namo: ?, colour: ?};" -F p='["Mustard", "Yellow", "Ketchup", "Red"]' -X POST http://localhost:3803/sql
```

NOTE: `--form-string` is required instead of `--form` to send semicolon-delimited
      statements with `curl`.
