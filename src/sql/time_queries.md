# Time Queries

To make best use of Time Queries, it is a good idea to review the
time-related SQL data types, such as `TIMESTAMP`, `DATE`, `TIME`,
and `INTERVAL`.
These are covered in the [SQL Data Types](data_types.md) section.

It is also a good idea to review Endb's other time-related functions,
in case they are helpful to you:

* [`STRFTIME`](functions.md#strftime)
* [`UNIXEPOCH`](functions.md#unixepoch)
* [`JULIANDAY`](functions.md#julianday)

## CURRENT_TIMESTAMP

`CURRENT_TIMESTAMP` gets the current time in UTC.

```sql
SELECT CURRENT_TIMESTAMP;
```

## CURRENT_DATE

`CURRENT_DATE` gets the current date in UTC.
Note that this may be different from your _local_ date,
depending on the time of day when your query is run.

```sql
SELECT CURRENT_DATE;
```

## BETWEEN

The syntax for time-aware `BETWEEN` is the same as the
[normal `BETWEEN` operator](operators.md#between).
Inspect System Time with the form `FOR SYSTEM_TIME BETWEEN x AND y`.

```sql
SELECT * FROM products FOR SYSTEM_TIME BETWEEN 2023-08-24T00:00:00 AND 2023-08-25T00:00:00;
```
