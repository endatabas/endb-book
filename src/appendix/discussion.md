# Discussion

## Single-Row Comparison

Should this be legal? There is more than one row in `coupons`:

```sql
-> SELECT { p.name, p.price } > (SELECT name, price FROM coupons) FROM products p;
[{'column1': True},
 {'column1': True},
 {'column1': True},
 {'column1': True},
 {'column1': True},
 {'column1': True},
 {'column1': True}]
```

I don't understand the semantics that cause this to return true:

```sql
SELECT [1, 2, 3] MATCH [1, 2, 2];
SELECT {user: {name: ['foo', 'bar']}, age: 42} MATCH {user: {name: 'bar'}};

SELECT ['foo', 'bar'] MATCH 'bar' -- true
-- vs
SELECT [1, 2, [1, 3]] MATCH [1, 3] -- false
```

Top-level order does not matter (because the expression isn't a value?),
but internal ordering does ... sometimes:

```sql
SELECT [1, 2, 3] MATCH [3, 1]; -- true
SELECT [1, 2, [1, 3]] MATCH [[1, 3]]; -- true
SELECT [1, 2, [1, 3]] MATCH [[3, 1]]; -- false
SELECT {a: [1, 2, {c: 3, x: 4}], c: 'b'} MATCH {a: [{x: 4}, 1]}; -- true? why?
```

Are these the expected behaviours of `HEX` and `UNHEX`?
Maybe I'm just tired but I'm not sure I understand what '3135' is.

```sql
-> SELECT HEX(15);
[{'column1': '3135'}]
-> SELECT UNHEX('3135');
[{'column1': b'15'}]
```

### Time Queries:

Note on SQL:2011 closed-open period model ...
it seems like this isn't true? Is that intentional?

### Information Schema:

Should we just expose it to read-only queries?
