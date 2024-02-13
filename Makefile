.PHONY: all clean jsdoc serve build

all: clean jsdoc pydoc build

clean:
	rm -rf tools/jsdoc/output
	rm -rf tools/pydoc/input
	rm -rf tools/pydoc/output

jsdoc:
	mkdir -p tools/jsdoc/output
	jsdoc2md -c tools/jsdoc/conf.json -f ../endb/clients/javascript/endb.mjs --heading-depth 4 --name-format --no-gfm --no-cache > tools/jsdoc/output/jsdoc.md
	cp tools/jsdoc/output/jsdoc.md src/reference/jsdoc.md

pydoc:
	cp -r ../endb/clients/python tools/pydoc/input
	mkdir -p tools/pydoc/output
	sphinx-apidoc --no-toc --full --append-syspath --extensions sphinx.ext.napoleon -o tools/pydoc/input/doc tools/pydoc/input/
	mv tools/pydoc/input/doc/endb.rst tools/pydoc/input/doc/endb.rst.undoc
	grep -v 'undoc-members' tools/pydoc/input/doc/endb.rst.undoc > tools/pydoc/input/doc/endb.rst
	cd tools/pydoc/input/doc/ && make markdown
	cp tools/pydoc/input/doc/_build/markdown/endb.md src/reference/pydoc.md

serve:
	./bin/serve.sh

build:
	./bin/build.sh
