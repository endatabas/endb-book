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

## Note on SQL:2011 closed-open period model

All Endb temporal predicates (`CONTAINS`, `OVERLAPS`, `PRECEDES`,
`SUCCEDES`, `IMMEDIATELY PRECEDES`, and `IMMEDIATELY SUCCEDES`)
follow the SQL:2011 standard's "closed-open period model".
This means that a period represents all times starting from (and including)
the start time up to (but excluding) the end time.

## CURRENT_TIMESTAMP

`CURRENT_TIMESTAMP` gets the current date and time in UTC.

```sql
SELECT CURRENT_TIMESTAMP;
```

## CURRENT_TIME

`CURRENT_TIME` gets the current time in UTC.

```sql
SELECT CURRENT_TIME;
```

## CURRENT_DATE

`CURRENT_DATE` gets the current date in UTC.
Note that this may be different from your _local_ date,
depending on the time of day when your query is run.

```sql
SELECT CURRENT_DATE;
```

## AS OF (Time Travel)

Endb permits time-traveling queries with the SQL:2011-compatible
`AS OF` operator.
The query will treat the `DATE` or `TIMESTAMP` supplied after `AS OF`
as if it were that time _now_.

```sql
SELECT * FROM products FOR SYSTEM_TIME AS OF 2023-08-25T00:00:00;
```

## BETWEEN

The syntax for time-aware `BETWEEN` is the same as the
[normal `BETWEEN` operator](operators.md#between).
Inspect System Time with the form `FOR SYSTEM_TIME BETWEEN x AND y`.

```sql
SELECT * FROM products FOR SYSTEM_TIME BETWEEN 2023-08-24T00:00:00 AND 2023-08-25T00:00:00;
```

## FROM ... TO

Selects rows which fall between the two times, similar to `BETWEEN`,
but is exclusive of both the start and end times.

```sql
SELECT * FROM products FOR SYSTEM_TIME FROM 2023-08-24T00:00:00 TO 2023-08-30T00:00:00;
```

## Period Predicates

### CONTAINS

Returns `TRUE` if the second period is contained within the first.

```sql
SELECT {start: 2001-01-01, end: 2001-04-01} CONTAINS {start: 2001-02-01, end: 2001-04-01};
```

### OVERLAPS

Returns `TRUE` if any part of the first period is found within the second.

```sql
SELECT {start: 2001-01-01, end: 2001-03-01} OVERLAPS {start: 2001-02-01, end: 2001-04-01};
```

### PRECEDES

Returns `TRUE` if the first period ends before the second period begins.

```sql
SELECT 2001-03-01 PRECEDES [2001-04-01T00:00:00Z, 2001-05-01];
```

### SUCCEDES

Returns `TRUE` if the first period begins after the second period ends.

```sql
SELECT 2001-06-01 SUCCEDES [2001-04-01T00:00:00Z, 2001-05-01];
```

### IMMEDIATELY PRECEDES

Returns `TRUE` if the first period ends exactly as the second period begins.

```sql
SELECT 2001-04-01 IMMEDIATELY PRECEDES [2001-04-01T00:00:00Z, 2001-05-01];
```

### IMMEDIATELY SUCCEDES

Returns `TRUE` if the first period begins exactly as the second period ends.

```sql
SELECT 2001-05-01 IMMEDIATELY SUCCEDES [2001-04-01T00:00:00Z, 2001-05-01];
```
