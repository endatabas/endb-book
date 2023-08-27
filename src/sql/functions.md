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
