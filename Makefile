all: template som ann

template: template/README.md
som: som/README.md
ann: ann/README.md

template/README.md: template/template.Rmd
	script/rmd_to_md.sh template/template.Rmd

som/README.md: som/som.Rmd
	script/rmd_to_md.sh som/som.Rmd

ann/README.md: ann/ann.Rmd
	script/rmd_to_md.sh ann/ann.Rmd

