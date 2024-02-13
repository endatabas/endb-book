.PHONY: all clean jsdoc serve build

all: clean jsdoc build

clean:
	rm -rf tools/jsdoc/output

jsdoc:
	mkdir -p tools/jsdoc/output
	jsdoc2md -c tools/jsdoc/conf.json -f ../endb/clients/javascript/endb.mjs --heading-depth 4 --name-format --no-gfm --no-cache > tools/jsdoc/output/jsdoc.md
	cp tools/jsdoc/output/jsdoc.md src/reference/jsdoc.md

serve:
	./bin/serve.sh

build:
	./bin/build.sh
