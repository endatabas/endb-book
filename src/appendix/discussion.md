# Discussion

## Bugs, maybe

### HTTP basic auth?

```
$ ./target/endb --username zig --password zag
$ curl --user zig:zag -d "SELECT * FROM users" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
unknown format: "+m"
```

On the server:

```
<ERROR> [00:19:35] endb/http http.lisp (make-api-handler fun9) -
  unknown format: "+m"
```

### select from non-existent table in new db

```
curl -d "SELECT * FROM users;" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
Invalid argument types: ARROW-GET(0, 0)
```

## Documentation

* empty
