# endb-book

The Endatabas Book

## Setup

```
cargo install mdbook
cargo install mdbook-linkcheck
```

## Limitations

The `mdbook-pdf` build has been removed for now, as the TOC is too buggy.
The HTML print feature works reasonably well.

## Open Questions

* where does the `Data Types` section go? this is key.
* the tutorial will flow more easily; how do we make the `SQL` section approachable?

## Inspiration

* https://archive.org/details/TheCProgrammingLanguageFirstEdition/mode/2up
* https://lalrpop.github.io/lalrpop/
* https://doc.rust-lang.org/stable/book/


## TODO

### HTTP

* JSON payload
* -F

### Parameters

* anonymous
* named

### Inspecting Schema

* hard-coded tables
* information_schema.tables / columns / views

### paths

* https://github.com/endatabas/endb/commit/688fec271078576738d93c89d4cc986016fe8dfb
* #:sql-path_remove #:sql-path_insert #:sql-path_replace #:sql-path_set
* extract: https://github.com/endatabas/endb/commit/0703dc07d75667c4d548dd392564d2293584673b
* https://www.sqlite.org/json1.html

* row literal vs. rows

### HTTP

steven@catu:~/work/endatabas/endb-book$ curl -d '{"q": "SELECT * from products;"}' -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:3803/sql
[["Salt"]]
steven@catu:~/work/endatabas/endb-book$
steven@catu:~/work/endatabas/endb-book$
steven@catu:~/work/endatabas/endb-book$
steven@catu:~/work/endatabas/endb-book$
steven@catu:~/work/endatabas/endb-book$
steven@catu:~/work/endatabas/endb-book$
steven@catu:~/work/endatabas/endb-book$ curl -d '{"q": "SELECT * from products WHERE name = ?;", "p": ["Salt"]}' -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:3803/sql
[["Salt"]]
steven@catu:~/work/endatabas/endb-book$ curl -d '{"q": "SELECT * from products WHERE name = ?;", "p": ["Sal"]}' -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:3803/sql
[]
steven@catu:~/work/endatabas/endb-book$ curl -d '{"q": "SELECT * from products WHERE name = :name;", "p": {"name": "Salt"}}' -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:3803/sql
[["Salt"]]
steven@catu:~/work/endatabas/endb-book$ curl -d '{"q": "SELECT * from products WHERE name = :name;", "p": [{"name": "Salt"}, {"name": "Pepper"}], "m": true}' -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:3803/sql
[]
steven@catu:~/work/endatabas/endb-book$ curl -d '{"q": "INSERT INTO products {name: :name};", "p": [{"name": "Paprika"}, {"name": "Pepper"}], "m": true}' -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:3803/sql
[[2]]
steven@catu:~/work/endatabas/endb-book$ curl -d '{"q": "SELECT * from products;"}' -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:3803/sql
[["Pepper"],["Paprika"],["Salt"]]

### transactions

* implicit, multi-statement post

### Literals

* spreads - arrays
* computeds, shorthand {x}, row literals - objects
* row literal section duplicated/separate
