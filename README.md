# endb-book

The Endatabas Book

## Setup

```
cargo install mdbook
cargo install mdbook-pdf
cargo install mdbook-toc
pip install mdbook-pdf-outline
# you'll need ~/.local/bin on your PATH
```

## Bugs

* `mdbook-pdf-outline` and/or mdbook itself has a bug in it
that prevents the outline page from rendering at all:
https://github.com/HollowMan6/mdbook-pdf#common-issues
...I'm not actually sure that link bug or the associated PR
fix the problem we're having, but the `writer.add_outline_item`
calls are never executed on our book. Hopefully the bug is
fixed soon. Issue raised:
    * https://github.com/HollowMan6/mdbook-pdf/issues/18

## Open Questions

* where does the `Data Types` section go? this is key.
* the tutorial will flow more easily; how do we make the `SQL` section approachable?

## Inspiration

* https://archive.org/details/TheCProgrammingLanguageFirstEdition/mode/2up
* https://lalrpop.github.io/lalrpop/
* https://doc.rust-lang.org/stable/book/
