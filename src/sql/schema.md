# Schema

Endb allows introspection of its information schema.
The Endb information schema does _not_ describe the structure of
each table.
Because Endb is a document database, each document (row) is responsible
for its own schema.
The information schema is used by Endb to describe database objects
at a high level and is used for schemaless queries, such as `SELECT *`.

Note that all information schema tables are hard-coded to
lower-case names and must be queried as such.

## Tables

```
-> SELECT * FROM information_schema.tables;
[{'table_catalog': None,
  'table_name': 'stores',
  'table_schema': 'main',
  'table_type': 'BASE TABLE'},
 {...
  'table_name': 'products',
  ... },
 {...
  'table_name': 'sales',
  ... }]
```

## Columns

```
-> SELECT * FROM information_schema.columns;
[{'column_name': 'addresses',
  'ordinal_position': 0,
  'table_catalog': None,
  'table_name': 'stores',
  'table_schema': 'main'},
 {'column_name': 'brand',
  ... },
 {'column_name': 'price',
  ... },
 ... ]
```

## Views

```
-> SELECT * FROM information_schema.views;
[{'table_catalog': None,
  'table_name': 'sold_products',
  'table_schema': 'main',
  'view_definition': 'SELECT * FROM products p JOIN sales s ON p.id = s.p_id'}]
```

## Check Constraints

The `check_constraints` table in Endb is used to store [assertions](assertions.md).

```
-> SELECT * FROM information_schema.check_constraints;
[{'check_clause': "(NOT EXISTS (SELECT * FROM users WHERE TYPEOF(email) != 'text'))",
  'constraint_catalog': None,
  'constraint_name': 'string_email',
  'constraint_schema': 'main'}]
```
