# Data Manipulation

Creating, updating, and deleting data in Endb is done using standard SQL Data Manipulation Language (DML).
Endb is also immutable and schemaless,
so it contains a number of shorthands and document-oriented conveniences.

Endb does not require any Data Definition Language (DDL), such as `CREATE TABLE`.

## INSERT

To create a new document, you can use the standard SQL `INSERT` command.

```sql
INSERT INTO products (product_no, name, price) VALUES (1, 'Tofu', 7.99);
```

To create multiple new documents at once, delimit their value lists with commas:

```sql
INSERT INTO products (product_no, name, price) VALUES (1, 'Butter', 5.99), (2, 'Margarine', 4.99);
```

It is also possible to insert a document directly using an
[`OBJECT` literal](data_types.md#object).

```sql
INSERT INTO products {product_no: 3, name: 'Tea', price: 3.99};
```

To insert multiple documents directly, delimit documents with commas:

```sql
INSERT INTO products {name: 'Coffee', price: 3.99}, {name: 'Croissant', price: 2.99};
```

It is possible to insert the results of a query:

```sql
INSERT INTO cheap_products SELECT * FROM products WHERE price < 4.00;
```

## UPDATE

To update an existing row, you can use the standard SQL `UPDATE` command:

```sql
UPDATE products SET price = 4.99 WHERE name = 'Coffee';
```

Set multiple columns by separating them with commads;

```sql
UPDATE products SET price = 4.99, name = 'Kaapi' WHERE name = 'Coffee';
```

Because Endb is schemaless, each document (or row) has its own schema.
As a result, you may want to remove a column from an individual row.
You can do this with the `UNSET` command:

```sql
UPDATE products UNSET product_no WHERE name = 'Coffee';
UPDATE products REMOVE product_no WHERE name = 'Coffee';
```

`REMOVE` is an alias for `UNSET`.

It is possible to set and unset values in a single update.
Unsetting a column which doesn't exist is not an error:

```sql
UPDATE products SET price = 5.98 UNSET product_no WHERE name = 'Coffee';
```

## UPDATE PATCH

Endb provides a `PATCH` operator, similar to the [`PATCH` function](functions.md#patch).
The `PATCH` operator is used in conjunction with `UPDATE`
to set fields on a document (columns on a row) in a declarative fashion.

```sql
UPDATE products PATCH {price: 1.98, product_no: products.product_no + 1000} WHERE price = 2.00;
```

## UPDATE SET $path

The `SET` operator permits [paths](path_navigation.md#path-functions)
on its left-hand side.
The behaviour of the form `UPDATE <table> SET <path> = <value>`
is identical to that of the [`path_set`](path_navigation.md#path_set)
function.

```sql
UPDATE users SET $.addresses[0].city = 'Chicago' WHERE name = 'Steven';
```

## DELETE

To delete an existing row, use the standard SQL `DELETE` command.

```SQL
DELETE FROM products WHERE price = 5.98;
```

You may delete all rows from a table by eliding the `WHERE` clause:

```SQL
DELETE FROM products;
```

## ON CONFLICT (Upsert)

Endb provides flexible upserts with the common `ON CONFLICT` clause.
When the `INSERT` command detects a conflict, it will perform the instructions in the `DO` clause.
The following command needs to be executed twice to see the upsert effect.

```sql
INSERT INTO products {name: 'Pepper', price: 9.99} ON CONFLICT (name, price) DO UPDATE SET v = 2;
```

To specify no operation on conflict, use `DO NOTHING`:

```sql
INSERT INTO products {name: 'Pepper', price: 9.99} ON CONFLICT (name, price) DO NOTHING;
```

To reference the document currently being inserted, the `DO` clause provides
a statement-local relation named `excluded`.

```sql
INSERT INTO products {name: 'Salt', price: 6};
INSERT INTO products {name: 'Salt', price: 7} ON CONFLICT (name) DO UPDATE SET price = excluded.price;
```

Similarly, the existing table is still available in the `DO` clause to provide further filtering:

```sql
INSERT INTO products {product_no: 99, name: 'Cumin', price: 3.00, v: 5};
INSERT INTO products {product_no: 99, name: 'Cumin', price: 5.00, v: 6} ON CONFLICT (product_no, name) DO UPDATE SET price = excluded.price, v = excluded.v WHERE products.v < 6;
```

## Parameters

Parameters to DML are documented under the [HTTP API](../reference/http_api.md).

## Transactions

Transactions in Endb are implicit.
Run multiple DML statements in a single transaction by providing multiple statements
(delimited by semicolons) to a single `POST` to the [HTTP API](../reference/http_api.md).
