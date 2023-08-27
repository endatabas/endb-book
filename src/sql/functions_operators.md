# Functions and Operators

## Boolean Operators

`WHERE` clauses can be modified and combined using standard SQL boolean operators.

```sql
SELECT * FROM products WHERE NOT name = 'Coffee';
SELECT * FROM products WHERE name = 'Coffee' OR name = 'Kaapi';
SELECT * FROM products WHERE name > 'Cake' AND price > 5.00;
```

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
