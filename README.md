# endb-book

The Endatabas Book

## Setup

```
cargo install mdbook
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

### DML

* patch, update patch

### Queries

* IN
* LIKE / regex / glob
* ARRAY_AGG
    * order: https://github.com/endatabas/endb/commit/f218446efc3b06accf715a5b76a58f41c861979a
* match: https://github.com/endatabas/endb/commit/0fbb285ea9ddda7c6b827f8d3aa3feb7df2ad056
    * containment: @> (convenience)

### Paths / Objects

* unnest, `object_keys`, `object_values`

### Functions

* fn list: https://github.com/endatabas/endb/blob/main/src/sql/expr.lisp
* SQLite fns: https://github.com/endatabas/endb/commit/8e7bb400db736f59ac84163a84da17fa337c82d4
