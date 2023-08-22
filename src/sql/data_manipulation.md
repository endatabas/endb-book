# Data Manipulation

Creating, updating, and deleting data in Endb is done using standard SQL Data Manipulation Language (DML),
but Endb contains a number of shorthands and document-oriented conveniences.

Endb does not require any Data Definition Language (DDL).

## Insert

To create a new document, you can use the standard SQL `INSERT` command.

```sql
INSERT INTO products (product_no, name, price) VALUES (1, 'Tofu', 7.99);
```

To create multiple new documents at once, delimit their value lists with commas:

```sql
INSERT INTO products (product_no, name, price) VALUES (1, 'Butter', 5.99), (2, 'Margarine', 4.99);
```

It is also possible to insert a document directly.

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

## Update

To update an existing row, you can use the standard SQL `UPDATE` command:

```sql
UPDATE products SET price = 4.99 WHERE name = 'Coffee';
```

Because Endb is schemaless, each document (or row) has its own schema.
As a result, you may want to remove a column from an individual row.
You can do this with the `UNSET` command:

```sql
UPDATE products UNSET product_no WHERE name = 'Coffee';
```

It is possible to set and unset values in a single update.
Unsetting a column which doesn't exist is not an error:

```sql
UPDATE products SET price = 5.98 UNSET product_no WHERE name = 'Coffee';
```

## Delete
