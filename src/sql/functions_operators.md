# Functions and Operators

## Boolean Operators

`WHERE` clauses can be modified and combined using standard SQL boolean operators.

```sql
SELECT * FROM products WHERE NOT name = 'Coffee';
SELECT * FROM products WHERE name = 'Coffee' OR name = 'Kaapi';
SELECT * FROM products WHERE name > 'Cake' AND price > 5.00;
```

## In: List Comparison

The standard SQL `IN` clause can be used to filter rows against lists.

```sql
SELECT * FROM products WHERE price IN (5.00, 5.99);
```
