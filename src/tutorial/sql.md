# Endb SQL

If you know SQL, Endb SQL will feel instantly familiar.
It is not "SQL-like". It _is_ SQL.
However, Endb SQL is _dynamic_, _strongly-typed_, _time-aware_, and _shuns language embedding_.
Hopefully it is pleasant to use without feeling foreign.

## Just Begin

Endb is a schemaless document database.
You do not need `CREATE TABLE` — tables are dynamically created when you insert data.
The following SQL is valid as soon as you start `endb`:

```SQL
INSERT INTO posts (id, user_id, text) VALUES (123, 456, 'Hello World');

SELECT * from posts;
```

## Immutable

Endb is immutable, so it does not permit destructive `UPDATE` or `DELETE`.
For example, if you run an `UPDATE`, your previous `INSERT` isn't lost.
Before we update the record, we'll make note of the current time, according to the database.
(Any time after the `INSERT` and before the `UPDATE` would suffice.)

```SQL
SELECT CURRENT_TIMESTAMP;
-- for the sake of example, let's say this returns 2023-08-17T00:00:00

UPDATE posts SET text = 'Hello Immutable World' WHERE id = 123;

SELECT * from posts;
```

You'll note that `Hello World` from your original insert isn't visible.
That's because it only exists in the past and, by default, `SELECT` will show the state of the database _as of now_.

To see the old version, you can time-travel back to a time when the old record was visible:

```SQL
SELECT * from posts FOR SYSTEM_TIME AS OF 2023-08-17T00:00:00;
```

NOTE: Although there is no `DELETE` in the traditional sense, there is `ERASE`,
which exists to remove data for user safety and compliance with laws like GDPR.

## Dynamic Joins

Relationships are also dynamic.
Adding a user with id `456` allows a join with the previous `posts` table.

```SQL
INSERT INTO users (id, name) VALUES (456, 'Vikram');

SELECT * from posts p JOIN users u ON p.user_id = u.id;
```

## Semi-Structured Data

Endb allows you to insert asymmetrical, jagged data.
Let's add another user with more columns.

```SQL
INSERT INTO users (id, name, email) VALUES (789, 'Daniela', 'daniela@endatabas.com');

SELECT * from users;
```

Note that the `SELECT *` is an implicitly dynamic query.
It doesn't have any difficulty with the previous `user` document, even though it lacked an `email` column.

## Data "Migration"

It may seem strange to leave jagged columns lying around.
Endb doesn't discourage you from cleaning up your data, if you can:

```SQL
UPDATE users SET email = vikram@stockholm.se' WHERE name = 'Vikram';

SELECT * from users;
```

The difference in Endb is that we haven't "migrated" the old data — it's still there.
If you query for Vikram's `user` document as of 2 minutes ago, you will see the old record without an `email`.
Queries in Endb always default to "as-of-now", which is why the results of the query above shouldn't be surprising.

## Nested Data

Endb eschews [nested json](https://www.postgresql.org/docs/current/datatype-json.html) in favour of
a native, strongly-typed, document-relational model.

```SQL
INSERT INTO users (id, name, friends) VALUES (123, 'Anastasia', [{name: 'Heikki', country: 'Finland'},{name: 'Amit', country: 'Japan'}]);

SELECT users.friends[1] FROM users WHERE id = 123;
```

The `users.friends[1]` path expression seen above is one of many inspired by [JSONPath](https://datatracker.ietf.org/doc/draft-ietf-jsonpath-base/),
[SQL/JSON](https://www.iso.org/standard/78937.html), and their derivatives in legacy relational databases.
A detailed explanation of Endb's arrays and objects is provided in the [Reference Docs](/reference/sql.md)

## Error Messages

Endb will always do its best to provide you with meaningful error messages that point you to a solution:

```sql
SELECT * FROM im_not_here;
```
