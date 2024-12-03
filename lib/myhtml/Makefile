CRYSTAL ?= crystal
CRYSTALFLAGS ?=

.PHONY: package spec
package: src/ext/myhtml-c/lib/libmodest_static.a

src/ext/myhtml-c/lib/libmodest_static.a:
	cd src/ext && make package

spec:
	crystal spec

.PHONY: clean
clean:
	rm -f bin_* src/ext/modest-c/lib/libmodest_static.a
	rm -rf ./src/ext/modest-c
