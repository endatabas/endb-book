# Discussion

## Booleans

Why on earth would SQLite allow this?

```
sqlite> select cast(0 as zig);
0
```

Does allowing this screw up 3VL, somehow?
SQLite doesn't have booleans, Oracle has `to_boolean`, T-SQL has `CAST(x AS BIT)`,
Apache Impala (?) _does_ have `CAST(0.0 AS BOOLEAN)`,
and Postgres supports `CAST('true' AS BOOLEAN)` ... but *not* numbers, apparently.

It feels like we should permit any (sane) `CAST(x AS <datatype>)` for at least one combination of `x` and each data type we list?

## Reals

This was surprising behaviour, though I'm not sure it should be?
(I'm curious why the lower-case version doesn't work, though.)

```
SQL> select cast('123.4' as real);
There is no applicable method for the generic function
  #<STANDARD-GENERIC-FUNCTION ENDB/SQL/EXPR:SQL-CAST (32)>
when called with arguments
  ("123.4" :|real|).
See also:
  The ANSI Standard, Section 7.6.6

SQL> select cast('123.4' AS REAL);
{"@context":{"xsd":"http://www.w3.org/2001/XMLSchema#","@vocab":"http://endb.io/"},"@graph":[{"column1":123.4}]}
```

This took me a second to parse... ;)

```
SQL> select 9.007199254740992e15
{"@context":{"xsd":"http://www.w3.org/2001/XMLSchema#","@vocab":"http://endb.io/"},"@graph":[{"e15":9.007199254740993}]}
```

## Numeric and Decimal

```
SQL> select -123456789012345678901234567890;
unknown panic!!
```

## Descriptions

Descriptions should probably refer only to their internal representation and not to interpretation or rendering, but
it's probably worth a chat.

## Posting json

...how?

## DELETE FROM table;

Should this work?

```
-> DELETE FROM users;
400 Bad Request
Error: found end of input expected something else
   ╭─[<unknown>:1:1]
   │
 1 │ DELETE FROM users;
   │ ───┬──
   │    ╰──── found end of input expected something else
```

## On Conflict - lingering columns (e)?

```
-> select * from t2;
[{'c': 4, 'e': 5, 'v': 3}]
-> delete from t2;
[{'result': 1}]
-> INSERT INTO t2 {c: 4, d: 6} ON CONFLICT (c) DO UPDATE SET d = excluded.d;
[{'result': 1}]
-> select * from t2
[{'c': 4, 'd': 6, 'e': None, 'v': None}]
```
