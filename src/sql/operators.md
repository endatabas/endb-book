# Operators

## Comparison

Two values can be compared using standard SQL comparison operators:

* `=` (equals)
* `>` (greater than)
* `<` (less than)
* `>=` (greater than or equal to)
* `<=` (less than or equal to)
* `<>` (not equal to)

```sql
SELECT * FROM products WHERE NOT name = 'Coffee';
SELECT * FROM products WHERE name = 'Coffee' AND name <> 'Kaapi';
SELECT * FROM products WHERE name > 'Cake' AND price >= 5.00;
```

## BETWEEN

`BETWEEN` returns `true` when a value is greater-than-or-equal-to the first limit
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

`IS` and `IS NOT` are used to test for `NULL`,
which is the third boolean value, representing "unknown":

```sql
SELECT * FROM products WHERE product_no IS NULL;
SELECT * FROM products WHERE product_no IS NOT NULL;
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

## LIKE

`LIKE` returns `true` if a string matches the supplied _LIKE_ pattern, as defined below:

A pattern can be a string literal.
It can also contain underscores (`_`) and/or percentage symbols (`%`).
An underscore matches exactly one character.
A percentage symbol matches zero or more characters.
Backslash escapes the following character to make it a literal.

```sql
SELECT * FROM products WHERE name LIKE 'Tofu';
SELECT * FROM products WHERE name LIKE 'Tof_';
SELECT * FROM products WHERE name LIKE '%of%';
SELECT * FROM products WHERE name LIKE '\%of\%';
```

`NOT LIKE` is used to invert the results of the match.

```sql
SELECT * FROM products WHERE name NOT LIKE '%of%';
```

NOTE: Endb `LIKE` is case-sensitive.

## REGEXP

`REGEXP` returns `true` if a string matches the supplied regular expression.
`REGEXP` may be prefixed with `NOT`.

```sql
SELECT * FROM products WHERE name REGEXP '.*ee|.*ea';
SELECT * FROM products WHERE name NOT REGEXP '.*[fst]+.*';
```

## GLOB

`GLOB` returns `true` if a string matches the supplied UNIX glob.
`GLOB` may be prefixed with `NOT`.

```sql
SELECT * FROM products WHERE name GLOB '*of*';
SELECT * FROM avatars WHERE filename NOT GLOB '/opt/local/avatars/**/*.png';
```

NOTE: `GLOB` is case-sensitive.

## MATCH (Containment)

`MATCH` returns `true` if the value on the left contains the value on the right, at the top level.

The following expressions return `true`:

```sql
SELECT 'foo' MATCH 'foo';
SELECT [1, 2, 3] MATCH [3, 1];
SELECT {user: 'foo', age: 42} MATCH {age: 42};
SELECT {a: [1, 2, {c: 3, x: 4}], c: 'b'} MATCH {a: [{x: 4}, 1]};
```

The following expressions return `false`:

```sql
SELECT [1, 2, [1, 3]] MATCH [1, 3];
SELECT {foo: {bar: 'baz'}} MATCH {bar: 'baz'};
SELECT {a: [1, 2, {c: 3, x: 4}], c: 'b'} MATCH {a: [{x: 4}, 3]};
```

NOTE: The `@>` operator is a synonym for `MATCH`.
It is provided as a convenience for users accustomed to the equivalent JSON Containment Operator in Postgres.

## EXISTS

`EXISTS` returns `true` if the subquery which follows it returns at least one row.

```sql
SELECT name FROM products WHERE EXISTS (SELECT 1 FROM coupons WHERE name = products.name);
```

## IN

The standard SQL `IN` clause can be used to test lists and subqueries for containment of a value.

```sql
SELECT * FROM products WHERE price IN (5.00, 5.99);
SELECT * FROM products WHERE price IN (SELECT price FROM coupons);
```

## NOT IN

The standard SQL `NOT IN` clause can be used to test lists and subqueries for absence of a value.

```sql
SELECT * FROM products WHERE price NOT IN (5.00, 5.99);
SELECT * FROM products WHERE price NOT IN (SELECT price FROM coupons);
```

## Single-Row Comparison

It is possible to compare
[row literals](data_types.md#row-literals)
against a subquery which returns exactly one row.

```sql
SELECT { p.name, p.price } < (SELECT name, price FROM coupons WHERE name = 'Tofurky' LIMIT 1) FROM products p;
```

## WITH ORDINALITY

When a set-returning function (such as [`UNNEST`](functions.md#unnest))
is used in a `FROM` clause, it can be suffixed with `WITH ORDINALITY`
to append an ordinal column to the results.

```sql
SELECT * FROM UNNEST([1.99, 2.99, 3.99]) WITH ORDINALITY AS products(price, n);
-- [{'n': 0, 'price': 1.99}, {'n': 1, 'price': 2.99}, {'n': 2, 'price': 3.99}]
```

NOTE: Endb ordinals are zero-indexed.

## Concatenation

The concatenation operator (`||`) concatenates two strings.
Multiple operators can be chained together.

```sql
SELECT 'Hello' || 'World';
SELECT "Hello" || "World" || "And" || "Friends";
```

The Concatenation Operator is equivalent to the [`CONCAT` function](functions.md#concat).
