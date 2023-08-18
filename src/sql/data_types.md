# SQL Data Types

## NULL

Null serves a variety of purposes in Endb.

* Explicit: You can provide an explicit `NULL` value
* "Unknown": As with any SQL, you will receive a null when [3-Valued Logic](https://en.wikipedia.org/wiki/Three-valued_logic#SQL)
  cannot determine if a statement is true or false
* "Missing": Jagged rows will return `NULL` for columns projected
  for a document which does not contain them

## VARCHAR

Endb accepts unbounded, variable-length strings with either single or double quotes.

```SQL
INSERT INTO users (name, title) VALUES ('River', "Prodigy");
```

## BOOLEAN

Boolean values can be `true`, `false`, or `NULL`.

## INTEGER

32-bit integers with a minimum value of -9007199254740991
and a maximum value of 9007199254740991.

## REAL

A 64-bit IEEE 754 floating point number, or double.

## BIGINT

32-bit integers with a minimum value of -9223372036854775807
and a maximum value of 9223372036854775807.

## TIMESTAMP

Timestamps can be represented as either SQL timestamps, according to the SQL Specification,
or ISO timestamps.
The following are legal timestamp literals:

* `2007-01-01T00:00:00`
* `2007-01-01T00:00:00.123Z`
* `2007-01-01T00:00:00.000000Z`
* `TIMESTAMP '2007-01-01 00:00:00'`
* `TIMESTAMP '2007-01-01 00:00:00.000000Z'`

## DATE

Dates can be represented as either SQL dates, according to the SQL Specification,
or ISO dates.
The following are legal date literals:

* `2007-01-01`
* `DATE '2007-01-01'`

## TIME

Times can be represented as either SQL times, according to the SQL Specification,
or ISO times.
The following are legal time literals:

* `23:59:12`
* `23:59:12.12345`
* `TIME '23:59:12'`
* `TIME '23:59:12.12345'`

## BLOB

Binary Large Objects can be encoded as literals or cast from strings.

* `x'DEADBEEF'`
* `CAST("hello" AS BLOB)`

## ARRAY

Arrays can be created using a syntax similar to that in the SQL Specification,
or array literals similar to JSON.

* `ARRAY("one", "two", "three")`
* `["one", "two", "three"]`

## OBJECT

Objects can be created using a syntax similar to that in the SQL Specification,
or object literals similar to JSON.

* `OBJECT(name: 'Hanna', birthday: 1982-12-31)`
* `{name: "Hanna", birthday: 1982-12-31}`
