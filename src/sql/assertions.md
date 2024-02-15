# Assertions

## CREATE ASSERTION

Creates a checked, deferred assertion which executes on commit
for inserts and updates.
Although `CREATE ASSERTION` (normally) refers to the table
it is asserting on, that table need not exist for the assertion to be created.

### Type Constraint

```sql
CREATE ASSERTION string_email CHECK (NOT EXISTS (SELECT * FROM users WHERE TYPEOF(email) != 'text'));
INSERT INTO users {name: 'Steven', email: 123};
```

### Unique Constraint

There are a number of possible ways to create the equivalent of a `UNIQUE` constraint,
as found in schema-on-write databases.
One sensible approach is given below.

```sql
CREATE ASSERTION unique_email CHECK (1 >= (SELECT MAX(c.cnt) FROM (SELECT COUNT(*) AS cnt FROM users GROUP BY email) AS c));
INSERT INTO users {name: 'Steven', email: 's@endatabas.com'};
INSERT INTO users {name: 'Sarah', email: 's@endatabas.com'};
```

### Not Null Constraint

There are multiple possible meanings to "not null" columns in Endb:
Columns can be strictly checked for literal `NULL` in the value position.
Rows can be forbidden from eliding a column (a missing value).
Both literal `NULL` and elided columns can both be prevented.

This example checks for literal `NULL` only:

```sql
CREATE ASSERTION notnull_email CHECK (NOT EXISTS (SELECT * FROM users WHERE email IS NULL));
INSERT INTO users {name: 'Tian Tian', email: NULL}; -- check fails
INSERT INTO users {name: 'Tian Tian'}; -- permitted
```

## DROP ASSERTION

Removes an assertion from the database based on its name.

```sql
DROP ASSERTION string_email;
```
