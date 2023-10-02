%.stl: template.scad
	openscad /dev/null -D "use <`pwd`/template.scad> $(basename $@)();" -o $@

all: $(foreach num, $(shell seq 0 6), template$(num).stl) cut.stl
