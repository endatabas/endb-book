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

```sql
SELECT * FROM information_schema.tables;
```

## Columns

```sql
SELECT * FROM information_schema.columns;
```

## Views

```sql
SELECT * FROM information_schema.views;
```

## Check Constraints

The `check_constraints` table in Endb is used to store [assertions](assertions.md).

```sql
SELECT * FROM information_schema.check_constraints;
```
