# Operators

## Comparison

Two values can be compared using standard SQL comparison operators:

* `=`, `==` (equals)
* `>` (greater than)
* `<` (less than)
* `>=` (greater than or equal to)
* `<=` (less than or equal to)
* `<>`, `!=` (not equal to)

```sql
SELECT * FROM products WHERE NOT name = 'Coffee';
SELECT * FROM products WHERE name = 'Coffee' AND name <> 'Kaapi';
SELECT * FROM products WHERE name > 'Cake' AND price >= 5.00;
```

## BETWEEN

`BETWEEN` returns `TRUE` when a value is greater-than-or-equal-to the first limit
and less-than-or-equal-to the second.
It has the form `BETWEEN x AND y`.
It can be negated with the form `NOT BETWEEN x AND y`.

```sql
SELECT * FROM products WHERE price BETWEEN 2.00 AND 4.00;
SELECT * FROM products WHERE price NOT BETWEEN 2.00 AND 4.00;
```

NOTE: `BETWEEN` can also be used with [System Time](time_queries.md#between).

## Boolean Operators

`WHERE` and `HAVING` clauses can be modified and combined with standard SQL boolean operators.

### IS, IS NOT

`IS` and `IS NOT` behave like [`=` (`==`) and `<>` (`!=`)](operators.md#comparison), respectively.
They are usually used to augment equality checks to test for `NULL`,
which is the third boolean value, representing "unknown".
The literal `UNKNOWN` is permitted in `IS` / `IS NOT` expressions in place of `NULL`.

* When both sides of `IS` evaluate to `NULL` it returns `TRUE`.
* When only one side of `IS NOT` evaluates to `NULL` it returns `TRUE`,
* When only one side of `IS` evaluates to `NUll` it returns `FALSE`.
* When both sides of `IS NOT` evaluates to `NULL` it returns `FALSE`.

```sql
SELECT * FROM products WHERE product_no IS NULL;
SELECT * FROM products WHERE product_no IS UNKNOWN;
SELECT * FROM products WHERE product_no IS NOT NULL;
SELECT * FROM products WHERE product_no IS 386;
SELECT * FROM products WHERE product_no IS NOT 444;
```

NOTE: A `WHERE` clause of the form `<column> IS NULL` will _not_ return
rows for which `<column>` does not exist, as positive equality is only
tested against extant columns.
For example, the query `SELECT * FROM products WHERE name IS NULL;` will
not return rows for which the column `name` does not exist.
However, `SELECT * FROM products WHERE name IS NOT NULL;` will not return
either rows where the `name` column has a value of `NULL` or the `name`
column is missing.
Thus, `IS` and `IS NOT` are not symmetrical for jagged data.

### IS \[NOT\] DISTINCT FROM

`IS DISTINCT FROM` is a synonym for `IS NOT`.
`IS NOT DISTINCT FROM` is a synonym for `IS`.

NOTE: The `IS [NOT] DISTINCT FROM` form is provided for SQL specification
compatibility and is not recommended, as it tends to be verbose and confusing.

### NOT, AND, OR

`NOT` can be prefixed to any clause to negate it:

```sql
SELECT * FROM products WHERE NOT (name = 'Coffee');
```

`AND` returns true if two clauses both return true:

```sql
SELECT * FROM products WHERE name = 'Coffee' AND price > 2.99;
```

`OR` returns true if either of two clauses return true:

```sql
SELECT * FROM products WHERE name = 'Coffee' OR name = 'Kaapi';
```

## Math

Standard SQL mathemetical operators are available to any two numeric values:

* `+` (addition)
* `-` (subtraction)
* `*` (multiplication)
* `/` (division)
* `%` (modulo; integer remainder of division)
* `<<` (left bit shift)
* `>>` (right bit shift)
* `+NUMBER` (unary plus)
* `-NUMBER` (unary minus)

```sql
SELECT 1 + 3.555;
SELECT 1 - 3.555;
SELECT 2 * 3.555;
SELECT 2 / 3.555;
SELECT 2 % 3.555;
SELECT 62 << 2;
SELECT 62 >> 2;
SELECT +128.5;
SELECT -128.5;
```

NOTE: Mathematical functions are documented under [Functions](functions.md#math).

## Bitwise Operators

Standard SQL bitwise manipulation operators are available to any two values.

* `&` (bitwise and)
* `|` (bitwise or)

The bitwise _not_ operator is also available to a single value:

* `~` (bitwise not)

```sql
SELECT 1 & 2;
SELECT 1 | 2;
SELECT ~1;
```

## LIKE

`LIKE` is the operator equivalent of the [`LIKE` function](functions.md#like).

`LIKE` returns `TRUE` if a string matches the supplied _LIKE_ pattern, as defined below:

A pattern can be a string literal.
It can also contain underscores (`_`) and/or percentage symbols (`%`).
An underscore matches exactly one character.
A percentage symbol matches zero or more characters.

Backslash escapes the following character to make it a literal.
Use `ESCAPE` to override the default backslash escape character.

```sql
SELECT * FROM products WHERE name LIKE 'Tofu';
SELECT * FROM products WHERE name LIKE 'Tof_';
SELECT * FROM products WHERE name LIKE '%of%';
SELECT * FROM products WHERE name LIKE '\%of\%';
SELECT * FROM products WHERE name LIKE 'X%ofX%' ESCAPE 'X';
```

`NOT LIKE` is used to invert the results of the match.

```sql
SELECT * FROM products WHERE name NOT LIKE '%of%';
```

NOTE: Endb `LIKE` is case-sensitive.

## REGEXP

`REGEXP` returns `TRUE` if a string matches the supplied regular expression.
`REGEXP` may be prefixed with `NOT`.

```sql
SELECT * FROM products WHERE name REGEXP '.*ee|.*ea';
SELECT * FROM products WHERE name NOT REGEXP '.*[fst]+.*';
```

## GLOB

`GLOB` returns `TRUE` if a string matches the supplied UNIX glob.
`GLOB` may be prefixed with `NOT`.

```sql
SELECT * FROM products WHERE name GLOB '*of*';
SELECT * FROM avatars WHERE filename NOT GLOB '/opt/local/avatars/*/*.png';
```

NOTE: `GLOB` is case-sensitive.
It conforms to standard UNIX globs and thus does not support "globstar"
(recursive directory) expansion like `**/*.png`.

## MATCH (Containment)

`MATCH` returns `TRUE` if the value on the left contains the value on the right,
at the top level.
Note that a top-level array to the right of the `MATCH` refers to a set of values
that all need to match, not a literal array.

The following expressions return `TRUE`:

```sql
SELECT 'foo' MATCH 'foo';
SELECT [1, 2, 3] MATCH [3, 1];
SELECT {user: 'foo', age: 42} MATCH {age: 42};
SELECT {a: [1, 2, {c: 3, x: 4}], c: 'b'} MATCH {a: [{x: 4}, 1]};
```

The following expressions return `FALSE`:

```sql
SELECT [1, 2, [1, 3]] MATCH [1, 3];
SELECT {foo: {bar: 'baz'}} MATCH {bar: 'baz'};
SELECT {a: [1, 2, {c: 3, x: 4}], c: 'b'} MATCH {a: [{x: 4}, 3]};
```

NOTE: The `@>` operator is a synonym for `MATCH`.
It is provided as a convenience for users accustomed to the equivalent
[JSON Containment Operator in Postgres](https://www.postgresql.org/docs/current/datatype-json.html#JSON-CONTAINMENT).
It also has a symmetric operator, `<@`, which returns `TRUE` if the value on the right
contains the value on the left, at the top level.
No symmetric keyword exists for `MATCH`.

## ANY, SOME

`SOME` is a synonym for `ANY`.
`ANY` qualifies a subquery by comparing a single column or literal value with the result of that subquery.
`ANY` is used in the form `<expression> <operator> ANY (<subquery>)`.
It returns true if the subquery returns a one or more values for which the operator is true.
The operator must return a boolean and the subquery must return a single column.

```sql
SELECT 1500 < SOME (SELECT price FROM products);
```

## ALL

`ALL` qualifies a subquery by comparing a single column or literal value with the result of that subquery.
`ALL` is used in the form `<expression> <operator> ALL (<subquery>)`.
It returns true only if all values returned by the subquery are true for the operator provided.
The operator must return a boolean and the subquery must return a single column.

```sql
SELECT "ok" = ALL (SELECT status_code FROM statuses);
```

## EXISTS

`EXISTS` returns `TRUE` if the subquery which follows it returns at least one row.

```sql
SELECT name FROM products WHERE EXISTS (SELECT 1 FROM coupons WHERE name = products.name);
```

## IN

The standard SQL `IN` clause can be used to test lists and subqueries for containment of a value.

```sql
SELECT * FROM products WHERE price IN (5.00, 5.99);
SELECT * FROM products WHERE price IN (SELECT price FROM coupons);
```

NOTE: Use [`MATCH`](operators.md#match) to test for containment of a value in an array.

## NOT IN

The standard SQL `NOT IN` clause can be used to test lists and subqueries for absence of a value.

```sql
SELECT * FROM products WHERE price NOT IN (5.00, 5.99);
SELECT * FROM products WHERE price NOT IN (SELECT price FROM coupons);
```

NOTE: Use [`MATCH`](operators.md#match) to test for absence of a value in an array.

## `||` (Concatenation)

The `||` operator concatenates two strings or arrays supplied as arguments.
When concatenating to an array element: other elements, arrays, and blobs are accepted as the second argument.
When concatenating to an array: arrays, blobs, and array elements are accepted as the second argument.
Elements other than strings are cast to strings when concatenated with each other.
Multiple operators can be chained together.

```sql
SELECT "Hello" || "World";
SELECT [1, 2, 3] || [4, 5, 6];
SELECT 1 || 2;
SELECT "Hello" || ["World"];
SELECT ["Hello"] || "World";
SELECT "Hello" || "World" || "And" || "Friends";
```

The Concatenation Operator is equivalent to the [`CONCAT` function](functions.md#concat).

## Vector Operators

{{#include vector_indexing.md}}

### `<->` (L2 or Euclidean Distance)

The L2 Distance operator (`<->`) compares two vectors by
[Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance).
It is symmetrical to the [`L2_DISTANCE`](functions.md#l2_distance) function.

```sql
SELECT * FROM (VALUES ([0,0,0]), ([1,2,3]), ([1,1,1]), (NULL), ([1,2,4])) AS t(val) WHERE val NOT NULL ORDER BY t.val <-> [3,3,3];
-- [{'val': [1, 2, 3]},
--  {'val': [1, 2, 4]},
--  {'val': [1, 1, 1]},
--  {'val': [0, 0, 0]}]
```

### `<=>` (Cosine Distance)

The Cosine Distance operator (`<=>`) compares two vectors by the complement of their
[Cosine Similarity](https://en.wikipedia.org/wiki/Cosine_similarity).
It is symmetrical to the [`COSINE_DISTANCE`](functions.md#cosine_distance) function.

```sql
SELECT val FROM (VALUES ([0,0,0]), ([1,2,3]), ([1,1,1]), ([1,2,4])) AS t(val) WHERE t.val <=> [3,3,3] NOT NULL ORDER BY t.val <=> [3,3,3];
-- [{'val': [1, 1, 1]},
--  {'val': [1, 2, 3]},
--  {'val': [1, 2, 4]}]
```

### `<#>` (Inverse Inner Product)

The Inverse Inner Product operator (`<#>`) compares two vectors by the inverse
of their [Inner Product](https://mathworld.wolfram.com/InnerProduct.html).
It is the inverse of the [`INNER_PRODUCT`](functions.md#inner_product) function.

```sql
SELECT val FROM (VALUES ([0,0,0]), ([1,2,3]), ([1,1,1]), (NULL), ([1,2,4])) AS t(val) WHERE val IS NOT NULL ORDER BY t.val <#> [3,3,3];
-- [{'val': [1, 2, 4]},
--  {'val': [1, 2, 3]},
--  {'val': [1, 1, 1]},
--  {'val': [0, 0, 0]}]
```
