all: template som ann tree hclust logit svm kmeans knn

template: template/README.md
som: som/README.md
ann: ann/README.md
tree: tree/README.md
hclust: hclust/README.md
logit: logit_regression/README.md
svm: svm/README.md
kmeans: kmeans/README.md
knn: knn/README.md

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

kmeans/README.md: kmeans/readme.Rmd
	script/rmd_to_md.sh kmeans/readme.Rmd

knn/README.md: knn/readme.Rmd
	script/rmd_to_md.sh knn/readme.Rmd

