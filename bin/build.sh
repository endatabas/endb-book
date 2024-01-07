#!/usr/bin/env bash

# defaults to ../output/ based on book.toml
mdbook build

(
    # copy into ../docs for Netlify / GitHub Pages
    mkdir -p $(dirname "$0")/../docs/
    cd $(dirname "$0")/../docs/
    cp -R ../output/html/. ./

    # inject plausible.io
    # TODO: see https://rust-lang.github.io/mdBook/format/configuration/renderers.html#custom-backend-commands
    # TODO: copy `_redirects` into /docs
)
