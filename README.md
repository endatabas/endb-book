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

* UPDATE SET $path == path_set
* object_[from]_entries: https://github.com/endatabas/endb/commit/7a050310d4a6f23256f2adf4b18b7726d77f5fb8
* unnest object

UNSET isn't strictly a command.
SELECT foo.*
columns are ordered in application/json.
comparison, also <>, !=
OFFSET
OBJECTS lists can be jagged, projects the superset of columns.
Set-operators - inconsistent casing?
VARCHAR is called TEXT (maybe list common aliases?).
BOOLEAN, consistent casing? TRUE etc.
INTEGER is treated as a single type, normally 64-bit wide but can become 128-bit.
INTERVAL can be created using classic SQL style.
Row-literals - worth mentioning this avoids widening and NULLs?
Spread, show object spreads?
Computed properties - mention implicit cast to string?
Shorthand properties are missing.
Glob - not treating ** special, maybe it should?
Single-row comparsion - row subqueries aren't implemented.
WITH ORDINALITY can only be used in UNNEST, would document it there.
CONCAT function has been renamed to ||, it can also concatenate blobs, arrays and add elements (first, last) to arrays.
PATCH is based on https://datatracker.ietf.org/doc/html/rfc7386
MIN, MAX - the function versions are 2-arity.
"All standard math functions" - might tone this down to SQLite's set of fns.
FROM/TO, would make it clearer which are parts of FROM and which are predicates.
Path navigation - don't want to give the impression you have to use row literals.
JSON-LD returns an enevelope when using curl.
Let's sanity check path-params with application/sql.
Bulk parameters, explicit mention of the nesting array.
Data types, TEXT instead of VARCHAR (as per SQLite).
Missing Interval/Duration.
No difference between integers. JSON numbers will overflow to xsd:integer at MAX_SAFE_INTEGER (53-bits).
Unsure about documenting the unsupported scalars.
Architecture page could need a refresher (SQLite focus etc).
ERASE isn't implemented yet.

In general it would be nice to avoid overflowing the examples so much?

* beef up tutorial
