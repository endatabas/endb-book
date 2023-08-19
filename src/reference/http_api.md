# HTTP API

At this experimental stage, only raw HTTP drivers are available.
Any HTTP client may be used but in the examples below, we'll use `curl`.

You can send SQL statements to `endb` over HTTP:

TODO: revisit all URLs with q and p, positional vs named

```sh
curl -d "INSERT INTO users (name) VALUES ('Tianyu')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "SELECT * FROM users" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

You can send SQL to `endb` with standard HTTP Verbs, Content Types, and Accept Headers.
Each one is outlined below.

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

### `application/sql`:

```sh
curl -d 'SELECT 1' -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

### `application/json`:

Resolves JSON-LD scalars

```sh
TODO
```

TODO: url/form-encoded, multipart, ld+json

## Accept Headers

The default returned content type is `application/json`.

### text/csv

`text/csv` returns comma-separated rows:

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

`application/json` returns rows as an array of JSON tuples:

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,DATE('2023-07-22'))) t1" -H "Content-Type: application/sql" -H "Accept: application/json" -X POST http://localhost:3803/sql
```

returns:

```
[[2,"2023-07-22"],[1,"hello"]]
```


### application/x-ndjson

`application/x-ndjson` returns newline-delimited JSON documents:

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,DATE('2023-07-22'))) t1" -H "Content-Type: application/sql" -H "Accept: application/x-ndjson" -X POST http://localhost:3803/sql
```

returns:

```json
{"column1":2,"column2":"2023-07-22"}
{"column1":1,"column2":"hello"}
```

### application/ld+json

`application/ld+json` returns documents of strongly-typed ("Linking Data") JSON records:

```sh
curl -d "SELECT * FROM (VALUES (1,'hello'), (2,DATE('2023-07-22'))) t1" -H "Content-Type: application/sql" -H "Accept: application/ld+json" -X POST http://localhost:3803/sql
```

returns:

```json
[[2,{"@value":"2023-07-22","@type":"xsd:date"}],[1,"hello"]]
```
