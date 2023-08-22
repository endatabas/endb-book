# Data Manipulation

Creating, updating, and deleting data in Endb is done using standard SQL Data Manipulation Language (DML),
but Endb contains a number of shorthands and document-oriented conveniences.

Endb does not require any Data Definition Language (DDL).

## Insert

To create a new document, use the `INSERT` command.

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
