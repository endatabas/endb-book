# Assertions

## CREATE ASSERTION

Creates a checked, deferred assertion which executes on commit
for inserts and updates.
Although `CREATE ASSERTION` (normally) needs to refer to the table
it is asserting on, that table need not exist for the assertion to be created.

```sql
CREATE ASSERTION string_email CHECK (NOT EXISTS (SELECT * FROM users WHERE TYPEOF(email) != 'text'));
INSERT INTO users {name: 'Steven', email: 123};
```

## DROP ASSERTION

Removes an assertion from the database based on its name.

```sql
DROP ASSERTION string_email;
```
