# Queries

Endb SQL strives to empower the query author.
Basic SQL queries should be familiar.
Advanced SQL queries should be simple.

## Select \*

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

## Select By Name

In programmatic environments, it is almost always preferable to query for specific columns by name:

```sql
SELECT product_no FROM products;
```

Select a list of columns by delimiting them with commas.
If your client accepts `text/csv` as a content type, columns will be returned in the order specified.
JSON keys are inherently unordered so the order of columns is ignored for accepted content types of
`application/json`, `application/x-ndjson`, and `application/ld+json`.

```sql
SELECT product_no, v, price, name FROM products;
```

## Where Filtering

Rather than returning the entire table, documents (rows) can be filtered with a `WHERE` clause.

```sql
SELECT * FROM products WHERE price > 4;
```

### Comparison

The most common way of filtering columns is to compare them.
Endb provides `=`, `>`, `<`, `>=`, `<=` operators.
These work on all column types, though comparing two disparate types may produce unexpected results.

```sql
SELECT * FROM products WHERE product_no = 99;
SELECT * FROM products WHERE price < 4;
SELECT * FROM products WHERE name >= 'Cabin';
```

### Aliases

For convenience, tables can be given aliases immediately following their name in the `FROM` clause.

```sql
SELECT p.name FROM products p;
```

This is most useful when joining tables, as seen below.

### Joins

Because Endb is schemaless, documents (rows) can be joined on any fields (columns) which have equivalent values.

```sql
INSERT INTO coupons {name: 'Salt', price: 3.0};
SELECT * FROM products p JOIN coupons c ON p.name = c.name;
```

### As: Alias Tables, Joins, and Columns

The `AS` operator can be used to provide an alias for a table or join.

```sql
SELECT p.name FROM products AS p;
```

It is also used to alias columns.
This is useful when column names conflict in a join.

```sql
SELECT p.price AS regular_price, c.price FROM products p JOIN coupons c ON p.name = c.name;
```

If the same column is specified more than once, the last reference to that column name
is the one which will be returned:

```sql
SELECT c.price, p.price FROM products p JOIN coupons c ON p.name = c.name;
```


### Advanced Filtering

More advanced filters are possible and documented in [Functions and Operators](/sql/functions_operators.md).
