.PHONY: all clean jsdoc serve build

all: clean jsdoc pydoc build

clean:
	rm -rf tools/jsdoc/output
	rm -rf tools/pydoc/input
	rm -rf tools/pydoc/output

jsdoc:
	mkdir -p tools/jsdoc/output
	jsdoc2md -c tools/jsdoc/conf.json -f ../endb/clients/javascript/endb.mjs --heading-depth 3 --name-format --no-gfm --no-cache > tools/jsdoc/output/jsdoc.md
	cp tools/jsdoc/output/jsdoc.md src/clients/jsdoc.md

pydoc:
	echo "Creating a local copy of the Python client..."
	cp -r ../endb/clients/python tools/pydoc/input
	mkdir -p tools/pydoc/output
	echo "Building pypdoc project with Sphinx..."
	sphinx-apidoc --no-toc --full --append-syspath --extensions sphinx.ext.napoleon -o tools/pydoc/input/doc tools/pydoc/input/
	mv tools/pydoc/input/doc/endb.rst tools/pydoc/input/doc/endb.rst.undoc
	grep -v 'undoc-members' tools/pydoc/input/doc/endb.rst.undoc > tools/pydoc/input/doc/endb.rst
	echo "Building markdown from pydoc..."
	cd tools/pydoc/input/doc/ && make markdown
	echo "Cleaning up markdown and copying into endb-book..."
	sed -i.bak 's/\*\[\*/\*\\\[\*/g' tools/pydoc/input/doc/_build/markdown/endb.md
	sed -i.bak 's/\*\]\*/\*\\\]\*/g' tools/pydoc/input/doc/_build/markdown/endb.md
	cp tools/pydoc/input/doc/_build/markdown/endb.md src/clients/pydoc.md

serve:
	./bin/serve.sh

build:
	./bin/build.sh
