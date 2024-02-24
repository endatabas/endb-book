# Endb SQL Basics

If you know SQL, Endb SQL will feel instantly familiar.
It is not "SQL-like". It _is_ SQL.
However, Endb SQL is _dynamic_, _strongly-typed_, _time-aware_, and _shuns language embedding_.
Hopefully it is pleasant to use without feeling foreign.

## Just Begin

Endb is a schemaless document database.
You do not need `CREATE TABLE` — tables are dynamically created when you insert data.
The following SQL is valid as soon as you start `endb`:

```sql
INSERT INTO posts (id, user_id, text) VALUES (123, 456, 'Hello World');
```

Try querying it out:

```sql
SELECT * FROM posts;
```

## Immutable

Endb is immutable, so it does not permit destructive `UPDATE` or `DELETE`.
For example, if you run an `UPDATE`, your previous `INSERT` isn't lost.

Before we update the record, we'll make note of the current time, according to the database.
(Any time after the `INSERT` and before the `UPDATE` would suffice.)

```sql
-- make note of this time to use below
SELECT CURRENT_TIMESTAMP;
```

Multiple statements can be separated by semicolons.
This time, we'll update the record and view it at once:

```sql
UPDATE posts SET text = 'Hello Immutable World' WHERE id = 123;

SELECT * from posts;
```

You'll note that `Hello World` from your original insert isn't visible.
That's because it only exists in the past and, by default, `SELECT` will show the state of the database _as of now_.

To see the old version, you can time-travel back to a time when the old record was visible.
Copy the timestamp you noted, _without_ the quotes, something like
`SELECT * from posts FOR SYSTEM_TIME AS OF 2024-01-01T00:00:00.000000Z;`:

```sql
SELECT * from posts FOR SYSTEM_TIME AS OF {YOUR_NOTED_TIMESTAMP};
```

NOTE: Although there is no `DELETE` in the traditional sense, there is `ERASE`,
which exists to remove data for user safety and compliance with laws like GDPR.

## Dynamic Joins

Relationships are also dynamic.
You can join any two tables on any two columns.
Adding a user with id `456` allows a join with the previous `posts` table.

```sql
INSERT INTO users (id, name) VALUES (456, 'Vikram');

SELECT * from posts p JOIN users u ON p.user_id = u.id;
```

## Semi-Structured Data

Endb allows you to insert asymmetrical, jagged data.
Let's add another user with more columns.

```sql
INSERT INTO users (id, name, email) VALUES (789, 'Daniela', 'daniela@endatabas.com');

SELECT * from users;
```

Note that the `SELECT *` is an implicitly dynamic query.
It doesn't have any difficulty with the previous `user` document, even though it lacked an `email` column.
In practice, most applications and SQL queries should specify exactly the columns they want to query.
`SELECT *` is really only for exploratory queries, so it shows you everything visible in the table.

## Data "Migration"

It may seem strange to leave jagged columns lying around.
Endb doesn't discourage you from cleaning up your data, if you can:

```sql
UPDATE users SET email = 'vikram@stockholm.se' WHERE name = 'Vikram';

SELECT * from users;
```

The difference in Endb is that we haven't "migrated" the old data — it's still there.
If you query for Vikram's `user` document as of 2 minutes ago, you will see the old record without an `email`.
Queries in Endb always default to _as-of-now_, which is why the results of the query above shouldn't be surprising.

## Nested Data

Endb eschews [nested json](https://www.postgresql.org/docs/current/datatype-json.html)
in favour of a native, strongly-typed, document-relational model.

```sql
INSERT INTO users (id, name, friends)
VALUES (123, 'Anastasia', [{name: 'Heikki', country: 'Finland'},
                           {name: 'Amit', country: 'Japan'}]);

SELECT users.friends[1] FROM users WHERE id = 123;
```

The `users.friends[1]` expression above is a _path expression_.
A detailed explanation of Endb's path navigation is provided in the
SQL Reference [Path Navigation docs](../sql/path_navigation.md).

## Documents

Because of Endb's native document-relational model, rows are documents and vice-versa.
You can use an `INSERT` statement to add a document directly to the database:

```sql
INSERT INTO users {id: 890,
                   name: 'Aaron',
                   friends: [{name: 'Jeff', country: 'Canada'},
                             {name: 'Kaia', country: 'Japan'}]};
```

## Error Messages

Endb will always do its best to provide you with meaningful error messages that point you to a solution:

```sql
SELECT * FROM im_not_here;
```

## Learn More

Much more detail on Endb SQL is provided in the [SQL Reference](../sql/).
