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

Duration constructor
UPDATE $.path supports UNSET/REMOVE
Parameters, might be worth mentioning what they look like (unlike how to actually pass them in).
Transactions/multiple-statements now support parameters (still returns a single, last result).
Select by Name: columns are ordered in application/json.
comparison, also <>, !=
UNNEST under queries.
HAVING together with GROUP BY.
BIGINT is just an alias for INTEGER.
REAL (DOUBLE, DECIMAL)
BLOB (VARBINARY)
Spread, show object spreads?
IS/NOT can be used with any rhs expression, not just literal nulls, it simply treats null as equal.
GLOB - should double asterisk do something special?
EXISTS - could maybe mention that we don't support ANY/SOME style subqueries, but they can always be rewritten as a correlated EXISTS.
NOT/IN - should we support arrays on the rhs, or mention that we don't - guess MATCH removes/overloads this need a bit?
Single Row Comparison - a bit confusing if a row is an object or not, this is kind of just an object compare. Think { foo.* } is what we would call a row literal.
CARDINALITY, not really a set thing, just an alias for LENGTH.
MIN/MAX are 2 and more arity.
Functions - more natural order/grouping of the page?
Temporal - would make the FROM SYSTEM_TIME and period predicate clearer apart. 3-parts: current_date etc, FROM and period predicates.
SUCCEEDS - spelling.
Path functions - the syntax is really a superset (dollar, hash) of a subset (not recursive or wildcards). Might be worth highlighting that these are what UPDATE SET/REMOVE use.
Path navigation - don't want to give the impression you have to use row literals.
Check Constraints - just assertions, nothing else in our system.
HTTP API - Parameters - worth mentioning and explaining the valid JSON-LD literals one can use somewhere. Parameters can also (in some formats) be SQL.
Let's sanity check path-params with application/sql.
Unsupported scalars, same comment as before, the examples numbers are Clojure-esque.
Architecture page could need a refresher (SQLite focus etc).

In general it would be nice to avoid overflowing the examples so much?

Overall - would be good to go over the error messages we generate ourselves for consistent language, uppercase keywords etc?

* remove code example overflows
* beef up tutorial
