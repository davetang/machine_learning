all: template som
template: template/README.md
som: som/README.md

template/README.md: template/template.Rmd
	script/rmd_to_md.sh template/template.Rmd

som/README.md: som/som.Rmd
	script/rmd_to_md.sh som/som.Rmd

