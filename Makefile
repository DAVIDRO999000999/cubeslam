
.SUFFIXES:
.PHONY: clean build build-min build-shaders build-geometry build-component

STYLES=$(wildcard styles/*.less)
GEOMETRY=$(wildcard lib/geometry/*.json)
GEOMETRY_JS=$(GEOMETRY:.json=.js)
SHADERS=$(wildcard lib/shaders/*.glsl)
SHADERS_JS=$(SHADERS:.glsl=.js)
COMPONENT=$(shell find lib -name "*.js" -type f)

build: build-shaders build-geometry build-component build-styles

build-min: build build/build.min.js

build-shaders: $(SHADERS_JS) lib/shaders/index.js

build-geometry: $(GEOMETRY_JS) lib/geometry/index.js

build-styles: $(STYLES)
	lessc $< > build/build.css

build-component: components/ $(COMPONENT) component.json
	component-build

components/:
	component-install

lib/shaders/%.js: lib/shaders/%.glsl
	cat $< | support/str-to-js > $@

lib/geometry/%.js: lib/geometry/%.json
	cat $< | support/str-to-js > $@

%.min.js: %.js
	uglifyjs $< > $@

clean: 
	rm -Rf build/ components/ $(GEOMETRY_JS) $(SHADERS_JS)