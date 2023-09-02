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

* try assertion on empty db - "you can refer to table that doesn't exist yet"
* Duration constructor
* UPDATE $.path supports UNSET/REMOVE
* Transactions/multiple-statements now support parameters (still returns a single, last result).
* revisit AS / Aliases
* revisit SELECT / mime types
* HAVING together with GROUP BY.
* IS/NOT can be used with any rhs expression, not just literal nulls, it simply treats null as equal.
* EXISTS - could maybe mention that we don't support ANY/SOME style subqueries, but they can always be rewritten as a correlated EXISTS.
* NOT/IN - should we support arrays on the rhs, or mention that we don't - guess MATCH removes/overloads this
* arrays - compares lexographically
* objects - compares on entries as arrays (of pairs)
* UTC - time-queries, data-types: mention we are only UTC
* Temporal - would make the FROM SYSTEM_TIME and period predicate clearer apart. 3-parts: current_date etc, FROM and period predicates.
    * nesting?
    * revisit page
* SUCCEEDS - spelling.
* Path functions - the syntax is really a superset (dollar, hash) of a subset (not recursive or wildcards). Might be worth highlighting that these are what UPDATE SET/REMOVE use.
* whitespace between examples in one box
* HTTP API - Parameters - worth mentioning and explaining the valid JSON-LD literals one can use somewhere. Parameters can also (in some formats) be SQL.
    * show JSON-LD map somewhere
* retry: Let's sanity check path-params (url params) with application/sql.
    * document functionality if it works

* ops: env vars, cmd line params, logging, data_dir
* Architecture page could need a refresher (SQLite focus etc).
* NorthWind equivalent?
* Functions - more natural order/grouping of the page?
* In general it would be nice to avoid overflowing the examples so much?

* remove code example overflows
* beef up tutorial
