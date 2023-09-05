# Functions

## OBJECT_KEYS

An object's keys can be selected using `OBJECT_KEYS`.

```sql
SELECT OBJECT_KEYS({original_price: 1.99, sale_price: 1.50, coupon_price: 1.40});
```

## OBJECT_VALUES

An object's values can be selected using `OBJECT_VALUES`.

```sql
SELECT OBJECT_VALUES({original_price: 1.99, sale_price: 1.50, coupon_price: 1.40});
```

## OBJECT_ENTRIES

Returns an array of key-value pairs representing the given object.

```sql
SELECT OBJECT_ENTRIES({a: 1, b: 2, c: 3});
-- [['a': 1], ['b': 2], ['c': 3]]
```

## OBJECT\_FROM\_ENTRIES

Constructs an object from an array of key-value pairs.

```sql
SELECT OBJECT_FROM_ENTRIES([['a', 1], ['b', 2], ['c', 3]]);
-- {a: 1, b: 2, c: 3}
```

## PATCH

The `PATCH` function takes two documents.
The document returned is the first document "patched" with any fields found in the second document.
If the second document does not specify a field, that field is left untouched.
If the second document specifies any fields with values of `NULL`, those fields are removed.

```sql
SELECT PATCH(
  {name: 'Salt', nutrition: {sodium: 100, ingredients: 'Kosher Salt'}},
  {name: 'Sea Salt', nutrition: {ingredients: NULL}}
);
```

The `PATCH` function has an equivalent operator for data manipulation:
[`UPDATE PATCH`](data_manipulation.html#update-patch)

## COALESCE

The `COALESCE` function returns its first non-null argument.
The following example returns `'zig'`:

```sql
SELECT COALESCE(NULL, NULL, 'zig', 'zag');
```

## CHARACTER_LENGTH

The `CHARACTER_LENGTH` function returns the number of unicode characters in a string.

```sql
SELECT CHARACTER_LENGTH('josé');
-- 4

SELECT CHARACTER_LENGTH('❤️🥫');
-- 3
```

## OCTET_LENGTH

The `OCTET_LENGTH` function returns the length of a string, in bytes (octets).

```sql
SELECT OCTET_LENGTH('josé');
-- 5

SELECT OCTET_LENGTH('❤️🥫');
-- 10
```

## LENGTH

The `LENGTH` function counts the number of entries in a collection.
When supplied with a string, it is a synonym for `CHARACTER_LENGTH`.

```sql
SELECT LENGTH([3, 2]);
SELECT LENGTH({name: 'Peas', price: 8.99, product_no: 77});
SELECT LENGTH('josé');
```

NOTE: `CARDINALITY` is an synonym for `LENGTH`.

## TRIM, LTRIM, RTRIM

The `TRIM`, `LTRIM`, and `RTRIM` functions trim surrounding whitespace,
whitespace to the left, and whitespace to the right of a string, respectively.

```sql
SELECT TRIM('  hello  ');
-- 'hello'

SELECT LTRIM('  hello  ');
-- 'hello  '

SELECT RTRIM('  hello  ');
-- '  hello'
```

## LOWER, UPPER

The `LOWER` and `UPPER` functions downcase and upcase a string, respectively.

```sql
SELECT LOWER('Relatable Algebra');
-- 'relatable algebra'

SELECT UPPER('Shouting Calculus');
-- 'SHOUTING CALCULUS'
```

## REPLACE

The `REPLACE` function returns the string in the first parameter,
with the second parameter (if found) replaced by the third.

```sql
SELECT REPLACE('Relatable Algebra', 'Rela', 'Infla');
```

## INSTR

The `INSTR` function returns the first character of a substring match on the second parameter,
if found, and `0` if it is not found.

```sql
SELECT INSTR('Coffee', 'ee');
```

## SUBSTRING

The `SUBSTRING` function returns the substring starting from the index provided as the second parameter.
If the (optional) third parameter is provided, the substring will be of that length (or less, if the end of the source string is reached).
`SUBSTR` is a synonym for `SUBSTRING`.

```sql
SELECT SUBSTRING('Hello Edgar', 4);
SELECT SUBSTR('Hello Edgar', 4, 2);
```

## UNICODE

The `UNICODE` function returns an integer unicode value for the first character
of the parameter given.

```sql
SELECT UNICODE('Adam');
```

## CHAR

The `CHAR` function returns a string corresponding to the supplied integer
character codes.

```sql
SELECT CHAR(65, 66, 67);
```

## `CONCAT`

`CONCAT` is equivalent to the [Concatenation Operator (||)](operators.md#concatenation)
except that `CONCAT` is limited to 2-arity applications and `||` can be chained.

## HEX, UNHEX

The `HEX` function takes a BLOB (or coerces its argument into a UTF-8 string,
which in turn is interpreted as a BLOB)
and turns the BLOB into an upper-case hexadecimal string.

The `UNHEX` function takes a hexadecimal string and turns it into a BLOB.
The hexadecimal string provided must contain _character pairs_.
`UNHEX` takes an optional second parameter: a string containing non-hexadecimal
characters to be ignored in the first parameter.
If non-hexadecimal characters are found in the first parameter but not ignored
in the second parameter, `UNHEX` returns `NULL`.

```sql
SELECT HEX(15);
-- '3135'

SELECT UNHEX('3135');
-- b'15'

SELECT UNHEX('3135ZZ', 'Z');
-- b'15'

SELECT UNHEX('3135ZZ', 'M');
-- NULL
```

## RANDOM

The `RANDOM` function returns a random integer.

```sql
SELECT RANDOM();
```

## RANDOMBLOB, ZEROBLOB

The `RANDOMBLOB` function returns a random binary large object of the size given, in bytes.
The `ZEROBLOB` function returns a zeroed-out binary large object of the size given, in bytes.

```sql
SELECT RANDOMBLOB(32);
SELECT ZEROBLOB(32);
```

## IIF

The `IIF` function is a conditional shorthand.
It returns the second parameter if the condition is true and the third parameter if the condition is false.

```sql
SELECT IIF(price > 5.99, 'Expensive!', 'Cheap') FROM products;
```

## Math

Endb provides standard SQL math functions based on SQLite's collection of math functions:

* ROUND
* SIN
* COS
* TAN
* SINH
* COSH
* TANH
* ASIN
* ACOS
* ATAN
* ASINH
* ACOSH
* ATANH
* ATAN2
* FLOOR
* CEILING, CEIL
* SIGN
* SQRT
* EXP
* POWER, POW
* LOG, LOG10
* LOG2
* LN
* DEGREES
* RADIANS
* PI
* ABS

NOTE: Endb follows the choice of most SQL databases and aliases `LOG` to `LOG10`
rather than `LN` (natural log), as specified by the SQL standard.

NOTE: Mathematical operators are documented under [Operators](operators.md#math).

## CAST

The `CAST` function forces a value into a particular data type.
Note that not all types are cast-compatible with each other.

```sql
SELECT CAST(price AS INTEGER) FROM products;
```

## NULLIF

The `NULLIF` function returns `TRUE` if the two supplied expressions are equal.

```sql
SELECT NULLIF(1, 1);
SELECT NULLIF(1, 'zig');
```

## STRFTIME

The `STRFTIME` function formats a date or time value as a string.

```sql
SELECT strftime('%Y/%m/%d', date('2001-01-01'));
SELECT strftime('%Y %m %d at %H %M %S', datetime('2001-01-01 03:04:05'));
```

## UNIXEPOCH

The `UNIXEPOCH` function returns the number of seconds since the UNIX epoch.
Accepts a `DATE`, `TIMESTAMP`, or `STRING`.

```sql
SELECT UNIXEPOCH('2023-01-01');
SELECT UNIXEPOCH(1970-01-01T00:00:00Z);
```

## JULIANDAY

The `JULIANDAY` function returns the Julian Day, which is the number of days since
noon in UTC on November 24, 4714 B.C.
Accepts a `DATE`, `TIMESTAMP`, or `STRING`.

```sql
SELECT JULIANDAY(1970-01-01);
```

## TYPEOF

The `TYPEOF` function returns the type of the provided value.

```sql
SELECT TYPEOF('hi2u');
SELECT TYPEOF(1.12345678901234);
SELECT TYPEOF(2018-01-01T00:00:00);
```

## Aggregate Functions

### MIN, MAX

The `MIN` and `MAX` functions return the minimum and maximum values for an expression,
respectively.

```sql
SELECT MIN(price) FROM products;
SELECT MAX(price) FROM products;
```

NOTE: `MIN` and `MAX` also have non-aggregate equivalents, which are 2-arity.
When used that way, they each return the minimum or maximum value of the two values provided.

### ARRAY_AGG

The `ARRAY_AGG` function concatenates the results of an expression into an array.
The parameter may be [ordered](queries.html#order-by-sorting-results)
within `ARRAY_AGG`.

```sql
SELECT ARRAY_AGG(price) FROM products;
SELECT ARRAY_AGG(name ORDER BY price DESC) FROM products;
```

Note that when operating on arrays, the arrays themselves will be concatenated,
not the contents of the arrays.
The result will be an array of one higher dimension:

```sql
SELECT ARRAY_AGG(x.column1) FROM (VALUES ([1,2]), ([3,4])) AS x;
-- [{'column1': [[1, 2], [3, 4]]}]
```

### GROUP_CONCAT

The `GROUP_CONCAT` function returns a string with concatenated
non-null values from a column or group.
Given a second parameter,
It defaults to a comma-delimited list, but the second (optional) parameter
can override the delimiter.

```sql
SELECT GROUP_CONCAT(name) FROM products;
SELECT GROUP_CONCAT(name, ':') FROM products;
```

### LIKE

The `LIKE` function serves the same purpose as the
[`LIKE` operator](operators.md#like).
However, the argument order is (effectively) reversed for the `LIKE` function,
to match the signature used in SQLite.
For the function version, the pattern is the first argument.
Optionally, an alternative escape character can be provided as a third argument.

```sql
SELECT * FROM users WHERE LIKE('Stev%', name);
SELECT * FROM users WHERE LIKE('EdgarX%', name, 'X');
```
