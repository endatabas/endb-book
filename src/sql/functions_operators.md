# Functions and Operators

## Boolean Operators

`WHERE` clauses can be modified and combined using standard SQL boolean operators.

```sql
SELECT * FROM products WHERE NOT name = 'Coffee';
SELECT * FROM products WHERE name = 'Coffee' OR name = 'Kaapi';
SELECT * FROM products WHERE name > 'Cake' AND price > 5.00;
```

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
[row literals](/sql/data_types.md#row-literals)
against a subquery which returns exactly one row.

```sql
SELECT { p.name, p.price } < (SELECT name, price FROM coupons WHERE name = 'Tofurky' LIMIT 1) FROM products p;
```
