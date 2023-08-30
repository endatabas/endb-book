# Discussion

## Assertions on new table

Should we allow users to run a `CREATE ASSERTION` before they insert any data?

```
-> CREATE ASSERTION string_email CHECK (NOT EXISTS (SELECT * FROM users WHERE TYPEOF(email) != 'text'));
400 Bad Request
Error: Unknown table
   ╭─[<unknown>:1:64]
   │
 1 │ CREATE ASSERTION string_email CHECK (NOT EXISTS (SELECT * FROM users WHERE TYPEOF(email) != 'text'));
   │                                                                ──┬──
   │                                                                  ╰──── Unknown table
───╯

```

## EOL comments in SQL

Should we allow this?

```
-> INSERT INTO users {name: 'Steven', email: 123}; -- fails
400 Bad Request
Error: found '-' expected something else
   ╭─[<unknown>:1:49]
   │
 1 │ INSERT INTO users {name: 'Steven', email: 123}; -- fails assertion
   │                                                 ┬
   │                                                 ╰── found '-' expected something else
───╯
```
