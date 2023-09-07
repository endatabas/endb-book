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

## TODO: Feedback Required / Later

* sub-TOC align with SUMMARY
* blob + hex/unhex => blob section
* coalesce => conditionals

* beef up tutorial

* NorthWind equivalent?
* remove code example overflows
* docker/podman --pull=always (doesn't work in podman 3.4.4, which is in the 22.04 repo)
