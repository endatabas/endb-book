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

sqlite> select hex(15);
3135
sqlite> select hex('15');
3135


