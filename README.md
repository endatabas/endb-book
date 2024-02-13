# endb-book

The Endatabas Book

## Setup

Clone the main `endb` repo in a sibling directory with `endb-book`:

```sh
cd .. && git clone git@github.com:endatabas/endb.git && cd endb-book
```

Make sure you have `cargo`, `npm`, and `pip` (Rust, Node, and Python) installed.
Then run:

```sh
cargo install mdbook
cargo install mdbook-linkcheck

npm install -g jsdoc
npm install -g jsdoc-to-markdown

pip install sphinx
pip install sphinx-markdown-builder                                                                                                                                                    │
pip install sphinx-autodoc-typehints
```

## Build

```sh
make
make serve  # to view locally
```

## Limitations

* There is no `mdbook-pdf` but the HTML print feature works reasonably well.

## Inspiration

* https://archive.org/details/TheCProgrammingLanguageFirstEdition/mode/2up
* https://lalrpop.github.io/lalrpop/
* https://doc.rust-lang.org/stable/book/

## TODO

* beef up tutorial
* remove code example overflows

## TODO: Feedback Required / Later

* NorthWind equivalent?
* docker/podman --pull=always (doesn't work in podman 3.4.4, which is in the 22.04 repo)
