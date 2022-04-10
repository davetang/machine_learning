all: template som ann tree

template: template/README.md
som: som/README.md
ann: ann/README.md
tree: tree/README.md

template/README.md: template/template.Rmd
	script/rmd_to_md.sh template/template.Rmd

som/README.md: som/som.Rmd
	script/rmd_to_md.sh som/som.Rmd

ann/README.md: ann/ann.Rmd
	script/rmd_to_md.sh ann/ann.Rmd

tree/README.md: tree/tree.Rmd
	script/rmd_to_md.sh tree/tree.Rmd

