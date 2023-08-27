#!/usr/bin/env bash

# defaults to ../docs/ (GitHub pages) based on book.toml
mdbook build

(
    mkdir -p $(dirname "$0")/../docs/
    cd $(dirname "$0")/../docs/
    # echo 'docs.endatabas.com' > CNAME
    cp -R ../output/html/. ./
)
