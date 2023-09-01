# SQL Data Types

## NULL

Null serves a variety of purposes in Endb.

* Explicit: You can provide an explicit `NULL` value
* "Unknown": As with any SQL, you will receive a null when [3-Valued Logic](https://en.wikipedia.org/wiki/Three-valued_logic#SQL)
  cannot determine if a statement is true or false
* "Missing": Jagged rows will return `NULL` for columns projected
  for a document which does not contain them

## TEXT (VARCHAR)

Endb accepts unbounded, variable-length strings with either single or double quotes.

```SQL
INSERT INTO users (name, title) VALUES ('River', "Prodigy");
```

## BOOLEAN

Boolean values can be `TRUE`, `FALSE`, or `NULL`.

## INTEGER (BIGINT)

64-bit integer capable of auto-promotion to 128-bit integer.

## REAL (DOUBLE)

A 64-bit IEEE 754 floating point number, or double.

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

## INTERVAL (DURATION)

An interval (or _duration_) is created whenever two times are subtracted.

```sql
SELECT 2001-01-02 - 2001-01-01;
```

Intervals literals can be constructed with
[ISO 8601 syntax](https://en.wikipedia.org/wiki/ISO_8601#Time_intervals):

* `PT12H30M5S`
* `P1Y2M10DT2H30M`

Interval literals can also be constructed with
the classic SQL intervals DSL:

* `INTERVAL '1-2' YEAR TO MONTH`
* `INTERVAL '0 12:34:56.789' DAY TO SECOND`

## BLOB (VARBINARY)

Binary Large Objects can be encoded as hexidecimal literals or cast from strings.

* `x'DEADBEEF'`
* `CAST("hello" AS BLOB)`

## ARRAY

Arrays can be created with array literals similar to JSON.

* `["one", "two", "three"]`

Alternatively, arrays can also be created using a literal syntax similar
to that in the SQL Specification or a constructor function.

* `ARRAY ["one", "two", "three"]`
* `ARRAY("one", "two", "three")`

Array literals can contain the [spread operator](data_types.md#spread)

```sql
SELECT [1, 2, ...[3, 4], 5];
-- [{'column1': [1, 2, 3, 4, 5]}]
```

## OBJECT

Objects (which can also be thought of as documents, or rows)
can be created with object literals enclosed in curly braces,
similar to JSON.
Keys in object literals can be quoted or unquoted.

* `{name: "Hanna", birthday: 1982-12-31}`
* `{'name': "Hanna", 'birthday': 1982-12-31}`

Alternatively, objects can be created using either an `OBJECT`
constructor keyword, similar to that in the SQL Specification.

* `OBJECT(name: 'Hanna', birthday: 1982-12-31)`

Object literals can contain
[spreads](data_types.md#spreads),
[computed fields](data_types.md#computed-fields),
[shorthands](data_types.md#shorthands), and
[row literals](data_types.md#row-literals).

```sql
SELECT { a: 1, ...[2, 3] };
-- [{'column1': {'0': 2, '1': 3, 'a': 1}}]
SELECT { foo: 2, ['foo' || 2]: 5 };
-- [{'column1': {'foo': 2, 'foo2': 5}}]
SELECT {p.name, c.discounted} FROM products p JOIN coupons c ON p.name = c.name;
-- [{'column1': {'discounted': 2.99, 'name': 'Salt'}}]
SELECT {product: {p.*}, discounted: c.discounted} FROM products p JOIN coupons c ON p.name = c.name;
-- [{'column1': {'discounted': 2.99, 'product': {'name': 'Salt', 'price': 5.99}}}]
```

## Dynamic Literals

### Row Literals

It is possible return an entire document (row) as a single literal value.
The syntax is akin to Postgres [`ROW` literals](https://www.postgresql.org/docs/current/rowtypes.html).
Unlike `table.*`, which pads non-existent columns with `NULL`,
a row literal returns exactly the schema specified for each individual row.

* `{ table.* }`

Example usage:

```sql
SELECT { products.* } FROM products;
```

### Spread

The Spread Operator (`...`, sometimes known as "splat")
can be used to directly flatten/unnest one collection
(an array, object, or row literal) into another.
Strings are treated as character collections.

```sql
SELECT [1, 2, ...[3, 4], 5];
-- [{'column1': [1, 2, 3, 4, 5]}]

SELECT [1, 2, ..."foo", 5];
-- [{'column1': [1, 2, 'f', 'o', 'o', 5]}]
```

If an array is spread into an object, its ordinals will be used as properties:

```sql
SELECT { a: 1, ...{b: 2} };
-- [{'column1': {'a': 1, 'b': 2}}]

SELECT { a: 1, ...[2, 3] };
-- [{'column1': {'0': 2, '1': 3, 'a': 1}}]
```

### Computed Fields

In the key/property position, square brackets are used to construct
computed fields in [object literals](data_types.md#object).
Computed fields are implicitly cast to string.

```sql
SELECT { foo: 2, [2 + 2]: 5 };
-- [{'column1': {'4': 5, 'foo': 2}}]
SELECT { foo: 2, ['foo' || 2]: 5 };
-- [{'column1': {'foo': 2, 'foo2': 5}}]
```

### Shorthands

Column names can be referred to in place of key-value pairs in
[object literals](data_types.md#object).

```sql
SELECT {p.name, c.discounted} FROM products p JOIN coupons c ON p.name = c.name;
-- [{'column1': {'discounted': 2.99, 'name': 'Salt'}}]
```
