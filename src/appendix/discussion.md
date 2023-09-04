# Discussion

## Bugs?

I might be trying these multiple statement params wrong, but this feels
like maybe an HTTP thing that the tests didn't catch?

```
$ curl -F q="INSERT INTO sauces {name: ?, color: ?}; INSERT INTO sauces {name: ?, color: ?};" -F p='["Mustard", "Yellow", "Ketchup", "Red"]' -X POST http://localhost:3803/sql
Warning: skip unknown form field: INSERT INTO sauces {name: ?, color: ?}
Required parameters: (1 0) does not match given: (0 1 2 3)

$ curl -F q="INSERT INTO sauces {name: ?, color: ?}; SELECT {name: ?, color: ?};" -F p='["Mustard", "Yellow", "Ketchup", "Red"]' -X POST http://localhost:3803/sql
Warning: skip unknown form field: SELECT {name: ?, color: ?}
Required parameters: (1 0) does not match given: (0 1 2 3)
```

## Documentation

CONCAT function has been renamed to ||, it can also concatenate blobs, arrays and add elements (first, last) to arrays.
* "elements"?

Let's sanity check path-params with application/sql.
* pending
