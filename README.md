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

* HTTP API - Parameters - worth mentioning and explaining the valid JSON-LD literals one can use somewhere. Parameters can also (in some formats) be SQL.
    * show JSON-LD map somewhere
* retry: Let's sanity check path-params (url params) with application/sql.
    * document functionality if it works

## TODO: Feedback Required / Later

* UPDATE UNSET/REMOVE
* Transactions/multiple-statements now support parameters (still returns a single, last result).
* whitespace between examples in one box
* ops: env vars, cmd line params, logging, data_dir
* Architecture page could need a refresher (SQLite focus etc).
* NorthWind equivalent?
* Functions - more natural order/grouping of the page?
* In general it would be nice to avoid overflowing the examples so much?

* remove code example overflows
* beef up tutorial
