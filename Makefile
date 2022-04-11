all: template som ann tree hclust logit svm

template: template/README.md
som: som/README.md
ann: ann/README.md
tree: tree/README.md
hclust: hclust/README.md
logit: logit_regression/README.md
svm: svm/README.md

template/README.md: template/readme.Rmd
	script/rmd_to_md.sh template/readme.Rmd

som/README.md: som/readme.Rmd
	script/rmd_to_md.sh som/readme.Rmd

ann/README.md: ann/readme.Rmd
	script/rmd_to_md.sh ann/readme.Rmd

tree/README.md: tree/readme.Rmd
	script/rmd_to_md.sh tree/readme.Rmd

hclust/README.md: hclust/readme.Rmd
	script/rmd_to_md.sh hclust/readme.Rmd

logit_regression/README.md: logit_regression/readme.Rmd
	script/rmd_to_md.sh logit_regression/readme.Rmd

svm/README.md: svm/readme.Rmd
	script/rmd_to_md.sh svm/readme.Rmd

