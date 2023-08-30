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

Should we allow this end-of-line comments in commands?

```
-> INSERT INTO users {name: 'Steven', email: 123}; -- fails assertion
400 Bad Request
Error: found '-' expected something else
   ╭─[<unknown>:1:49]
   │
 1 │ INSERT INTO users {name: 'Steven', email: 123}; -- fails assertion
   │                                                 ┬
   │                                                 ╰── found '-' expected something else
───╯
```

## Documentation

comparison, also <>, !=
* these were documented already?

Row-literals - worth mentioning this avoids widening and NULLs?
* this is documented, I think (let's check)

Spread, show object spreads?
* this is documented?

Shorthand properties are missing.
* documented

Glob - not treating ** special, maybe it should?
* discuss

CONCAT function has been renamed to ||, it can also concatenate blobs, arrays and add elements (first, last) to arrays.
* "elements"?

FROM/TO, would make it clearer which are parts of FROM and which are predicates.
* added example is clear enough?

Let's sanity check path-params with application/sql.
* pending

Unsure about documenting the unsupported scalars.
* pending
