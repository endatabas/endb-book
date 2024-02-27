# Views

Endb provides basic view functionality.

## CREATE VIEW

`CREATE VIEW` creates a non-materialized view based on the query
which follows the `AS` operator.
Column names are listed in parentheses after the view name.

```sql
CREATE VIEW simple_products(name, price) AS SELECT name, ROUND(price) FROM products;
```

Alternatively, named columns can each immediately follow queried columns.

```sql
CREATE VIEW easy_products AS SELECT name label, ROUND(price) easy_price FROM products;
```

NOTE: To modify a view, use `DROP VIEW` then re-create the view with the desired columns.

## DROP VIEW

`DROP VIEW` deletes a view based on its name.

```sql
DROP VIEW easy_products;
```
