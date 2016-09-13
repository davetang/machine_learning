setwd("~/github/machine_learning/variant/random_forest/")

data <- read.csv("../DataS1/ToolScores/humvar_tool_scores.csv")
head(data)

features <- c('MutationTaster','MutationAssessor','PolyPhen2','CADD','SIFT','LRT','FatHMM.U','GERP..','PhyloP')

library(dplyr)

# see https://gist.github.com/djhocking/62c76e63543ba9e94ebe
data_subset <- select_(data, .dots=c('True.Label', features))
data_subset$True.Label <- factor(data_subset$True.Label)

table(data_subset$True.Label)

library(randomForest)

r <- randomForest(True.Label ~ ., data=data_subset, importance=TRUE, do.trace=100, na.action=na.omit, ntree=1000)

varImpPlot(r)

library(ROCR)

# use votes, which are the fraction of (OOB) votes from the random forest
# in the first row, all trees voted for class 0, which is benign
head(r$votes)

my_pred_vector <- as.numeric(names(r$predicted))
pred <- prediction(r$votes[,2], as.numeric(data_subset$True.Label[my_pred_vector]))
perf <- performance(pred,"tpr","fpr")
plot(perf)

# Area under the curve
auc <- performance(pred, measure = "auc")
auc@y.values

legend('bottomright', legend = paste("AUC = ", auc@y.values))
