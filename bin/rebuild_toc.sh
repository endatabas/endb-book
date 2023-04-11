#!/usr/bin/env bash

# NOTE: assumes execution from root
# FIXME: TOC links are broken (we can probably just drop them completely)

cp src/SUMMARY.md src/TOC.md
sed -i.bak '/TOC.md/d' src/TOC.md
