# Discussion

## Bugs?

```
-> UPDATE users UNSET $.addresses[0].city WHERE name = 'Steven';
500 Internal Server Error
A StructArray must contain at least one field

-> UPDATE users UNSET $.addresses[0] WHERE name = 'Steven';
500 Internal Server Error
Unhandled memory fault at #x5.
```

## Documentation

CONCAT function has been renamed to ||, it can also concatenate blobs, arrays and add elements (first, last) to arrays.
* "elements"?

Let's sanity check path-params with application/sql.
* pending
