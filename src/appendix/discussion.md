# Discussion

## Descriptions

Descriptions should probably refer only to their internal representation and not to interpretation or rendering, but
it's probably worth a chat.

## Posting json

...how?

## On Conflict - lingering columns (e)?

...it occurs to me this is normal, since it's just the widest set of columns known. Duh.

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
