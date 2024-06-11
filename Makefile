all: template som ann tree hclust logit svm kmeans knn naive_bayes xgboost random_forest eval pca caret tidymodels deep_learning

template: template/README.md
som: som/README.md
ann: ann/README.md
tree: tree/README.md
hclust: hclust/README.md
logit: logit_regression/README.md
svm: svm/README.md
kmeans: kmeans/README.md
knn: knn/README.md
naive_bayes: naive_bayes/README.md
xgboost: xgboost/README.md
random_forest: random_forest/README.md
eval: evaluation/README.md
pca: pca/README.md
caret: caret/README.md
tidymodels: tidymodels/README.md
deep_learning: deep_learning/README.md

template/README.md: script/rmd_to_md.sh template/readme.Rmd
	$^

som/README.md: script/rmd_to_md.sh som/readme.Rmd
	$^

ann/README.md: script/rmd_to_md.sh ann/readme.Rmd
	$^

tree/README.md: script/rmd_to_md.sh tree/readme.Rmd
	$^

hclust/README.md: script/rmd_to_md.sh hclust/readme.Rmd
	$^

logit_regression/README.md: script/rmd_to_md.sh logit_regression/readme.Rmd
	$^

svm/README.md: script/rmd_to_md.sh svm/readme.Rmd
	$^

kmeans/README.md: script/rmd_to_md.sh kmeans/readme.Rmd
	$^

knn/README.md: script/rmd_to_md.sh knn/readme.Rmd
	$^

naive_bayes/README.md: script/rmd_to_md.sh naive_bayes/readme.Rmd
	$^

xgboost/README.md: script/rmd_to_md.sh xgboost/readme.Rmd
	$^

random_forest/README.md: script/rmd_to_md.sh random_forest/readme.Rmd
	$^

evaluation/README.md: script/rmd_to_md.sh evaluation/readme.Rmd
	$^

pca/README.md: script/rmd_to_md.sh pca/readme.Rmd
	$^

caret/README.md: script/rmd_to_md.sh caret/readme.Rmd
	$^

tidymodels/README.md: script/rmd_to_md.sh tidymodels/readme.Rmd
	$^

deep_learning/README.md: script/rmd_to_md.sh deep_learning/readme.Rmd
	$^
