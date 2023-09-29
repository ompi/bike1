%.stl: template.scad
	openscad /dev/null -D "use <`pwd`/template.scad> $(basename $@)();" -o $@

all: $(addsuffix .stl, template)
