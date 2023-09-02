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

`WHERE` clauses can be modified and combined with standard SQL boolean operators:

`IS` and `IS NOT` behave like [`=` (`==`) and `<>` (`!=`)](operators.md#comparison), respectively.
They are usually used to augment equality checks to test for `NULL`,
which is the third boolean value, representing "unknown".

* When both sides of `IS` evaluate to `NULL` it returns `TRUE`.
* When only one side of `IS NOT` evaluates to `NULL` it returns `TRUE`,
* When only one side of `IS` evaluates to `NUll` it returns `FALSE`.
* When both sides of `IS NOT` evaluates to `NULL` it returns `FALSE`.

```sql
SELECT * FROM products WHERE product_no IS NULL;
SELECT * FROM products WHERE product_no IS NOT NULL;
SELECT * FROM products WHERE product_no IS 379;
```

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

## EXISTS

`EXISTS` returns `TRUE` if the subquery which follows it returns at least one row.

```sql
SELECT name FROM products WHERE EXISTS (SELECT 1 FROM coupons WHERE name = products.name);
```

NOTE: `ANY` and `SOME` are not supported by Endb, but they can both be created as
correlated `EXISTS` queries instead.

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

## Concatenation

The concatenation operator (`||`) concatenates two strings.
Multiple operators can be chained together.

```sql
SELECT 'Hello' || 'World';
SELECT "Hello" || "World" || "And" || "Friends";
```

The Concatenation Operator is equivalent to the [`CONCAT` function](functions.md#concat).
