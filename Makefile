all: template/README.md

template/README.md: template/template.Rmd
	script/rmd_to_md.sh template/template.Rmd

