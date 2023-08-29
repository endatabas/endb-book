# Path Navigation

Because Endb is schemaless and semi-structured, it
offers a number of powerful path-nativation primitives
inspired by
[JSONPath](https://datatracker.ietf.org/doc/draft-ietf-jsonpath-base/),
[SQL/JSON](https://www.iso.org/standard/78937.html),
and their derivatives in legacy relational databases.

You will want to familiarize yourself with Endb's
[nested data types](data_types.md) (arrays and objects)
before learning about path navigation.

## Nested Objects

If you are familiar with arrays and objects, try adding
some nested objects to the table `paths` (the table name is arbitrary).

```sql
INSERT INTO paths {a: 2, b: {a: 3}, c: [{a: 1}, 2]};
```

## Root Navigation

Navigating the root of any document (row) as a tree looks
like standard SQL, because it is:

```sql
SELECT a FROM paths;
```

Similarly, however, it is possible to navigate documents
listed in an array:

```sql
SELECT [{a: 2}, {a: 3}, {b: 4}].a;
-- [{'a': [2, 3]}]
```

It is also possible to navigate fields of sub-documents
(columns of nested rows) with further dot notation:

```sql
SELECT b.a FROM paths;
-- [{'a': 3}]
```

## Row Literals

It is possible (and helpful) to create a row literal to
represent rows returned, so they are easier to navigate.
The format of a row literal is `{ <table>.* }`:

```sql
SELECT { paths.* } FROM paths;
```

## Recursive Paths

The double dot (`..`) notation performs a "deep scan" by
recursively walking the document to match the name given.

```sql
SELECT { paths.* }..a FROM paths;
-- [{'a': [2, 3, 1]}]
```

## Named Child

The square bracket notation (`['<NAME>']`) performs a lookup
of a single descendent child.

```sql
SELECT { paths.* }['b']['a'] FROM paths;
-- [{'a': 3}]
```

Named Children can be combined with recursive paths,
though the default recursive path syntax is synonymous with
named children:

```sql
SELECT { paths.* }..a FROM paths;
SELECT { paths.* }..['a'] FROM paths;
```

Both of the above expressions return `[{'a': [2, 3, 1]}]`.

## Numbered Child

The square bracket notation (`[<NUMBER>]`) can also perform indexed
lookups of a single descendent child.

```sql
SELECT { paths.* }['b'][0] FROM paths;
-- [{'column1': {'a': 3}}]
SELECT { paths.* }['c'][1] FROM paths;
-- [{'column1': 2}]
```

Numbered Children can be combined with recursive paths.
This finds and returns all indexed values, counting backward:

```sql
SELECT { paths.* }..[-1] FROM paths;
-- [{'column1': [2]}]
```

## Wildcard Child

The square bracket notation (`[*]`) can also perform a wildcard
lookup of all descendent children.

```sql
SELECT [{a: 2}, {a: 3}, {b: 4}, 5][*];
```

Wildcards can be combined with recursive paths.
This finds and returns _all_ values:

```sql
SELECT { paths.* }..[*] FROM paths;
-- [{'column1': [2, {'a': 3}, [{'a': 1}, 2], 3, {'a': 1}, 2, 1]}]
```
