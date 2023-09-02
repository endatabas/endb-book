# Queries

Endb SQL strives to empower the query author.
Basic SQL queries should be familiar.
Advanced SQL queries should be simple.

## SELECT \*

The most common hand-written SQL query tends to be the easiest:

```sql
SELECT * FROM products;
```

Without a `WHERE` clause (discussed below) the entire table is returned.
Because Endb is schemaless, `*` has a special meaning.
Each document (row) in Endb carries with it its own schema.
As a result, `*` refers to the widest possible set of columns, across all the rows returned.

In many SQL dialects, columns are strictly ordered.
Because Endb columns cannot have a strict order, `*` returns them in alphabetical order.

You can select the widest set of columns for a specific table with `<table>.*`:

```sql
SELECT p.* FROM products p JOIN coupons c ON p.price = c.price;
```

## SELECT

In programmatic environments, it is almost always preferable to query for specific columns by name:

```sql
SELECT product_no, price FROM products;
```

Select a list of columns by delimiting them with commas.

```sql
SELECT product_no, v, price, name FROM products;
```

NOTE: Whether or not your Endb client respects column ordering is dependent
on the content type it uses in Accept Headers.
It is worth reading over the [Accept Header](../reference/http_api.md#accept-header)
documentation, in this regard.

## FROM

### Alias Tables

For convenience, tables can be given aliases immediately following their name in the `FROM` clause.

```sql
SELECT p.name FROM products p;
```

The `AS` operator can also (optionally) be used to provide an alias for a table.

```sql
SELECT p.name FROM products AS p;
```

More usefully, it can give a temporary table name to an expression.
The temporary table name can either have anonymous columns or named columns.
(The [`VALUES` keyword](queries.md#values-lists) is explained in the following
_VALUES Lists_ section.)

```sql
SELECT p.column1 FROM (VALUES ('Paprika', 4.77)) AS p;
SELECT p.price FROM (VALUES ('Paprika', 4.77)) AS p(name, price);
```

### Alias Columns

The `AS` keyword is also used to alias columns.
This is useful when column names conflict in a join.
(Joins are explained below.)
If the same column is specified more than once, the last reference to that column name
is the one which will be returned:

```sql
SELECT c.price, p.price FROM products p JOIN coupons c ON p.name = c.name;
```

If both columns are required, `AS` can be used to rename one or both of the columns:

```sql
SELECT p.price AS regular_price, c.price FROM products p JOIN coupons c ON p.name = c.name;
```

### JOIN

Because Endb is schemaless, documents (rows) can be joined
on any fields (columns) which have equivalent values.

```sql
INSERT INTO coupons {name: 'Salt', price: 3.0};
SELECT * FROM products p JOIN coupons c ON p.name = c.name;
```

### UNNEST

The `UNNEST` function can be thought of as the inverse of
[`ARRAY_AGG`](functions.md#array_agg),
although it offers more power than just unlinking elements.
It takes an array or object and pulls its elements into separate rows.

```sql
SELECT * FROM UNNEST([1.99, 2.99, 3.99]) AS products(price);
```

It is possible to unnest multiple arrays.
If the arrays do not have the same number of elements, the shorter array(s) will
have those values filled with `NULL`:

```sql
SELECT names.* FROM (VALUES (['Leslie', 'Edgar', 'fiver2'], ['Lamport', 'Codd'])) AS x(first, last), UNNEST(x.first, x.last) AS names(first, last);
```

When unnesting an object, keys-value pairs will be returned
as per [object\_entries](functions.md#object_entries).
This behaviour is useful for manipulating collections:

```sql
SELECT * FROM UNNEST({original_price: 1.99, sale_price: 1.50, coupon_price: 1.40}) AS prices(price);
-- [{'price': ['sale_price', 1.5]},
--  {'price': ['coupon_price', 1.4]},
--  {'price': ['original_price', 1.99]}]
```

### WITH ORDINALITY

`UNNEST` can be suffixed with `WITH ORDINALITY`
to append an ordinal column to the results.

```sql
SELECT * FROM UNNEST([1.99, 2.99, 3.99]) WITH ORDINALITY AS products(price, n);
-- [{'n': 0, 'price': 1.99}, {'n': 1, 'price': 2.99}, {'n': 2, 'price': 3.99}]
```

NOTE: Endb ordinals are zero-indexed.


## WHERE (Filtering)

Rather than returning the entire table, documents (rows) can be filtered with a `WHERE` clause.

```sql
SELECT * FROM products WHERE price > 4;
```

### Advanced Filtering

More advanced filters are documented in [Operators](operators.md)
and [Functions](functions.md).


## ORDER BY (Sorting Results)

Results from queries can be ordered with standard SQL `ORDER BY`.

```sql
SELECT * FROM products ORDER BY price;
```

By default, ordering is ascending.
For descending order, suffix the `ORDER BY` clause with `DESC`:

```sql
SELECT * FROM products ORDER BY price DESC;
```

To force ascending order, use `ASC`:

```sql
SELECT * FROM products ORDER BY price ASC;
```

It is also possible to order by an expression:

```sql
SELECT * FROM products ORDER BY LENGTH(name);
SELECT * FROM products ORDER BY -price;
```

In the example above, `LENGTH` is an example of a function.
A complete list of functions can be found in the [Functions](functions.md) documentation.

## GROUP BY

`GROUP BY` accepts a list of columns and creates aggregated rows based on
each of those columns, in order.
Each aggregate is returned as a single row.
Each column returned must either be a column specified in the `GROUP BY`
clause or a column created with an [aggregate function](functions.md#aggregate-functions),
such as `SUM`.

```sql
SELECT name, price FROM products GROUP BY name, price;
SELECT name, sum(price) FROM products GROUP BY name;
```

## HAVING

`HAVING` adds a search condition to an aggregate query.

```sql
SELECT name, sum(price) FROM products GROUP BY name HAVING LENGTH(name) > 4;
```

It is most often used with `GROUP BY` (seen above), but it is also legal
with other aggregates:

```sql
SELECT SUM(products.price) FROM products HAVING SUM(products.price) = 13;
```

## LIMIT

`LIMIT` specifies the maximum number of rows to be returned by the query.

```sql
SELECT * FROM products LIMIT 2;
```

It always makes sense to control the order of returned rows so `LIMIT`
always returns the same rows for the same query
-- unless you don't care which rows are returned.

```sql
SELECT * FROM products ORDER BY price ASC LIMIT 2;
```

`OFFSET` allows queries to skip rows before returning a limited set.

```sql
SELECT * FROM products ORDER BY price ASC LIMIT 2 OFFSET 2;
```

## VALUES Lists

The `VALUES` keyword is used to create a static table of documents (rows).
Each row is denoted by a pair of parentheses.
All rows must have [Union Compatibility](queries.md#union-compatibility)
which, for Endb, means they have the same number of columns.

```sql
VALUES (1, 'Salt'), (2, 'Pepper'), (3, 'Vinegar');
```

Endb assigns anonymous columns the names `column1`, `column2`, etc.
Columns can instead be given names with a
[table alias](queries.md#as-alias-tables-expressions-and-columns):

```sql
SELECT * FROM (VALUES (1, 'Salt'), (2, 'Pepper'), (3, 'Vinegar')) AS t (product_no, name);
```

## OBJECTS Lists

The `OBJECTS` keyword is used to create a static table comprised of
object literals, each representing a document (row).
Each row is directly denoted by an object literal.
`OBJECTS` lists do _not_ require [Union Compatibility](queries.md#union-compatibility),
so jagged lists are permitted.

```sql
OBJECTS {product_no: 1, name: 'Salt'}, {product_no: 2, name: 'Pepper', price: 3.99};
SELECT * FROM (OBJECTS {product_no: 1, name: 'Salt'}, {product_no: 2, name: 'Pepper'}) as t;
```

## Set Operations: UNION, INTERSECT, EXCEPT

The set operations union, intersection, and difference
are available to the results of two queries.

### UNION

Append the results of one query to another.
Duplicate rows are removed.

```sql
SELECT * FROM products UNION SELECT * FROM new_products;
```

To keep duplicate rows, use `UNION ALL`:

```sql
SELECT * FROM products UNION ALL SELECT * FROM new_products;
```

### INTERSECT

The intersection of two queries returns results which are found in both.

```sql
SELECT * FROM products INTERSECT SELECT * FROM new_products;
```

### EXCEPT

The difference of two queries returns only results from the first query which are not found in the second.
Another way of thinking about this is that results of the second query are removed from the first.

```sql
SELECT * FROM products EXCEPT SELECT * FROM ignored_products;
```

### Union-Compatibility

"Union Compatibility" refers to the ability of two queries to be used in a union, intersection, or difference.
Because Endb is dynamically-typed, the only constraint on union compatibility is the number of columns returned.

In general, it only makes sense to use set operations on two queries which return either: (1) explicit columns, so
order and naming are respected or (2) columns with the same names, so they are guaranteed to return in order, in
the case of `*` queries.
When applying set operations to `*` queries, keep in mind that the widest column set (across the entire history of
the table) will be returned.

If the queries return a different number of columns, set operations will result in an error:

```sql
-> SELECT * FROM products UNION SELECT * FROM new_products;
400 Bad Request
Number of UNION left columns: 3 does not match right columns: 2
```


## WITH Queries (Common Table Expressions)

The `WITH` keyword is used to create _Common Table Expressions_, or CTEs.
CTEs act like temporary tables or views within the context of a query.
CTEs are used in place of a sub-select to simplify the appearance of a query.
`WITH` clauses take the form `WITH <cte-name> AS (<cte-select>)`.

```sql
WITH top_margin_products AS (SELECT product_no FROM products WHERE (price - cost) > 5.00)
SELECT name FROM products
WHERE product_no IN (SELECT product_no FROM top_margin_products);
```

## WITH RECURSIVE

The `RECURSIVE` keyword can be added to `WITH` to create recursive CTEs
which can refer to themselves.
Recursive CTEs will always have the form `<initial-select> UNION <recursive-select>`
or `<initial-select> UNION ALL <recursive-select>`.

Here is a naive example, demonstrating the recursive construction of a Fibonacci Sequence:

```sql
WITH RECURSIVE fib(previous, current) AS (
  VALUES (0, 1)
    UNION ALL
  SELECT fib.current, fib.previous + fib.current
  FROM fib
  WHERE fib.previous + fib.current < 5000
)
SELECT * FROM fib;
```

The most beneficial uses for `WITH RECURSIVE` are walking hierarchical and graph-shaped data sets
-- capabilities ordinary SQL lacks.
However, Endb recursive queries are also capable of solving Sudoku puzzles and constructing fractals,
[as seen in the test suite](https://github.com/endatabas/endb/blob/main/test/sql.lisp).
(Credit goes to SQLite's delightful
[Outlandish Recursive Query Examples](https://www.sqlite.org/lang_with.html#outlandish_recursive_query_examples).)
