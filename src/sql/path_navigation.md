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

See [Row Literal Data Type](data_types.md#row-literals)

## Recursive Paths

The double dot (`..`) notation performs a "deep scan" by
recursively walking the document to match the name given.

```sql
SELECT { paths.* }..a FROM paths;
-- [{'a': [2, 3, 1]}]
SELECT b..a FROM paths;
-- [{'a': [3]}]
```

## Named Child

The square bracket notation (`['<NAME>']`) performs a lookup
of a single descendent child.

```sql
SELECT { paths.* }['b']['a'] FROM paths;
-- [{'a': 3}]
SELECT b['a'] FROM paths;
-- [{'a': 3}]
```

Named Children can be combined with recursive paths,
though the default recursive path syntax is synonymous with
named children:

```sql
SELECT { paths.* }..a FROM paths;
SELECT { paths.* }..['a'] FROM paths;
SELECT b..['a'] FROM paths;
```

## Numbered Child

The square bracket notation (`[<NUMBER>]`) can also perform indexed
lookups of a single descendent child.

```sql
SELECT { paths.* }['b'][0] FROM paths;
-- [{'column1': {'a': 3}}]
SELECT { paths.* }['c'][1] FROM paths;
-- [{'column1': 2}]
SELECT c[1] FROM paths;
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
SELECT c..[*] FROM paths;
-- [{'column1': [{'a': 1}, 2, 1]}]
```

## Path Functions

Path editing is accomplished with an extended path syntax, where each
path begins with `$`.
Endb's path editing functions are heavily inspired by
[SQLite's JSON Functions](https://www.sqlite.org/json1.html).

### `path_set`

Takes an object, a path, and a new value.
The new value will overwrite existing fields or add a new field if it
doesn't already exist.

```sql
SELECT path_set({a: 2, c: 4}, $.c, [97,96]);
-- {'a': 2, 'c': [97, 96]}
```

### `path_replace`

Takes an object, a path, and a new value.
The new value is ignored if the path does not match an existing field.

```sql
SELECT path_replace({a: 2, c: 4}, $.a, 99);
-- {'a': 99, 'c': 4}
SELECT path_replace({a: 2, c: 4}, $.e, 99);
-- {'a': 2, 'c': 4}
```

### `path_insert`

Takes an object, a path, and a new value.
The new value is ignored if the path matches an existing field.

```sql
SELECT path_insert({a: 2, c: 4}, $.e, 99);
-- {'a': 2, 'c': 4, 'e': 99}
```

### `path_remove`

Takes an object and a variable number of arguments specifying which paths to remove.
If a path is not found, nothing is removed for that argument.
`#` represents the last element in a collection.

```sql
SELECT path_remove([0,1,2,3,4], $[#-1], $[0]);
-- [1, 2, 3]
SELECT path_remove({x: 25, y: 42}, $.y);
-- {'x': 25}
```

### `path_extract`

Takes an object and a variable number of path arguments.
Returns the value found at each path, if any, otherwise `NULL`.
If only a single path is provided, a scalar is returned.
If multiple paths are provided, an array is returned.

```sql
SELECT path_extract({a: 2, c: [4, 5, {f: 7}]}, $.c[2].f);
-- 7
SELECT path_extract({a: 2, c: [4, 5], f: 7}, $.x, $.a);
-- [NULL, 2]
```
