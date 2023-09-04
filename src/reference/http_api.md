# HTTP API

At this experimental stage, only raw HTTP drivers are available.
Any HTTP client may be used but in the examples below, we'll use `curl`.

You can send SQL statements to `endb` over HTTP:

```sh
curl -d "INSERT INTO users (name) VALUES ('Tianyu')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "SELECT * FROM users" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

You can send SQL to `endb` with standard HTTP Query Parameters, Verbs,
Content Types, and Accept Headers.
Each one is outlined below.

## HTTP Query Parameters

The query parameters Endb's HTTP endpoint accepts are:

* `q` - (q)uery: a SQL query, optionally parameterized
* `p` - (p)arameters: named or positional [parameters](http_api.md#parameters)
* `m` - (m)ultiple statements: [bulk parameters](http_api.md#bulk-parameters), used for bulk insert/update

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
curl -d '{"q": "SELECT * from products WHERE name = ? AND price > ?;", "p": ["Salt", 3.99]}' -H "Content-Type: application/json" -X POST http://localhost:3803/sql
curl -d '{"q": "INSERT INTO events {start: ?};", "p": [{"@type": "xsd:dateTime", "@value": "2011-04-09T20:00:00Z"}]}' -H "Content-Type: application/ld+json" -X POST http://localhost:3803/sql
curl -F q="INSERT INTO products {name: ?};" -F p='["Sriracha"]' -X POST http://localhost:3803/sql
```

### Bulk Parameters

Bulk operations are possible by turning the `m` flag to `true`.
Bulk operations are available to both named and positional parameters.
The list of parameters supplied in bulk must be nested in an array.

```sh
curl -d '{"q": "INSERT INTO products {name: :name};", "p": [{"name": "Soda"}, {"name": "Tonic"}], "m": true}' -H "Content-Type: application/json" -X POST http://localhost:3803/sql
curl -F q="INSERT INTO sauces {name: ?, color: ?};" -F p='[["Mustard", "Yellow"], ["Ketchup", "Red"]]' -F m=true -X POST http://localhost:3803/sql
```

### Bulk Statements

It is possible to pass multiple SQL statements to Endb by delimiting
them with semicolons.
Parameters will be passed to all statements in order.

```sh
curl --form-string q="INSERT INTO sauces {name: ?, color: ?}; SELECT {namo: ?, colour: ?};" -F p='["Mustard", "Yellow", "Ketchup", "Red"]' -X POST http://localhost:3803/sql
```

NOTE: `--form-string` is required instead of `--form` to send semicolon-delimited
      statements with `curl`.
