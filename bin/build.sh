#!/usr/bin/env bash

# defaults to ../docs/ (GitHub pages) based on book.toml
mdbook build

(
    cd $(dirname "$0")/../docs/
    echo 'docs.endatabas.com' > CNAME
)
