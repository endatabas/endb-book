# Functions

## ARRAY_AGG

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

## GROUP_CONCAT

The `GROUP_CONCAT` function returns a string with concatenated
non-null values from a column or group.
Given a second parameter,
It defaults to a comma-delimited list, but the second (optional) parameter
can override the delimiter.

```sql
SELECT GROUP_CONCAT(name) FROM products;
SELECT GROUP_CONCAT(name, ':') FROM products;
```

## UNNEST

The `UNNEST` function can be thought of as the inverse of `ARRAY_AGG`,
although it offers more power than just unlinking elements.
It takes an array or object and pulls its elements into separate rows.

```sql
SELECT * FROM UNNEST([1.99, 2.99, 3.99]) AS products(price);
```

It is possible to unnest multiple arrays.
If the arrays do not have the same number of elements, the shorter array(s) will
have those values filled with `NULL`:

```sql
SELECT names.* FROM (VALUES (['Leslie', 'Edgar', 'fiver2'], ['Lamport', 'Codd'])) AS x(first, last), UNNEST(x.first, x.last) AS names(first, last);
```

When unnesting an object, keys and values will be made explicit within
[row literals](data_types.html#row-literals).
This behaviour is useful for manipulating collections:

```sql
SELECT * FROM UNNEST({original_price: 1.99, sale_price: 1.50, coupon_price: 1.40}) AS prices(price);
-- [{'price': {'key': 'sale_price', 'value': 1.5}},
--  {'price': {'key': 'coupon_price', 'value': 1.4}},
--  {'price': {'key': 'original_price', 'value': 1.99}}]
```

To append an ordinal to each row in the results, use
[`WITH ORDINALITY`](operators.html#with-ordinality).

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

## CARDINALITY

The `CARDINALITY` function returns the number of the elements in a given set.

```sql
SELECT CARDINALITY([3,3,4,5,6]) AS element_count;
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

## HEX, UNHEX

The `HEX` function takes a decimal number and turns it into a hexidecimal string.
The `UNHEX` function takes a hexidecimal string and turns it into a decimal number.

```sql
SELECT HEX(15);
-- '3135'
SELECT UNHEX('3135');
-- b'15'
```

## INSTR

The `INSTR` function returns the first character of a substring match on the second parameter,
if found, and `0` if it is not found.

```sql
SELECT INSTR('Coffee', 'ee');
```

## MIN, MAX

The `MIN` and `MAX` functions return the minimum and maximum values for an expression,
respectively.

```sql
SELECT MIN(price) FROM products;
SELECT MAX(price) FROM products;
```

## UNICODE

The `UNICODE` function returns an integer unicode value for the first character
of the parameter given.

```sql
SELECT UNICODE('Adam');
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
