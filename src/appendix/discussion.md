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

### Information Schema:

Should we just expose it to read-only queries?

### HEX / UNHEX:

The behaviour of HEX and UNHEX seem asymmetrical with SQLite.
UNHEX is harder to test, though, since sqlite just barfs out
some unicode characters as a result. Still, it seems the representation
of the BLOB produced by Endb's UNHEX shouldn't rely on the input
parameter (maybe?). Similarly, HEX shouldn't rely on the type of the
input parameter, I don't think.
SQLite does support round-tripping.

sqlite> select hex(15);
3135
sqlite> select hex('15');
3135

-> select hex(15);
[{'column1': '3135'}]
-> select hex('15');
[{'column1': '15'}]

sqlite> select unhex('F1');
<some unicode>
sqlite> select hex(unhex('F1'));
F1
sqlite> select unhex('3135');
15

-> select unhex('F1');
[{'column1': b'\xf1'}]
-> select unhex('3135');
[{'column1': b'15'}]
