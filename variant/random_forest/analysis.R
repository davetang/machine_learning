setwd("~/github/machine_learning/variant/random_forest/")

data <- read.csv("../DataS1/ToolScores/humvar_tool_scores.csv", stringsAsFactors = FALSE)
head(data)

features <- c('MutationTaster','MutationAssessor','PolyPhen2','CADD','SIFT','LRT','FatHMM.U','GERP..','PhyloP')

library(dplyr)

# Select columns by vector of names using dplyr
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

# cases with NaN were omitted
# create vector to store cases that were used
my_pred_vector <- as.numeric(names(r$predicted))

# votes for 1
pred <- prediction(r$votes[,2], as.numeric(data_subset$True.Label[my_pred_vector]))
perf <- performance(pred,"tpr","fpr")
plot(perf)

# area under the curve
auc <- performance(pred, measure = "auc")
auc@y.values
legend('bottomright', legend = paste("AUC = ", auc@y.values))

# matrix with votes and true label
votes_and_truth <- cbind(r$votes, data$True.Label[my_pred_vector])
votes_and_truth <- as.data.frame(votes_and_truth)
names(votes_and_truth) <- c('Negative','Positive','True')

# dplyr magic
filter(votes_and_truth, Positive>0.50) %>%
  select(True) %>%
  group_by(True) %>%
  tally(True)
# A tibble: 2 x 2
#    True     n
#   <dbl> <dbl>
# 1    -1 -2169
# 2     1 14783

filter(votes_and_truth, Negative>0.50) %>%
  select(True) %>%
  group_by(True) %>%
  tally(True)
# A tibble: 2 x 2
#     True      n
#    <dbl>  <dbl>
#  1    -1 -12454
#  2     1   2364

# find absolutely misclassified examples
# classified as positive but is really negative
# i.e. false positive
filter(votes_and_truth, Positive==1, True==-1)

# need row information
votes_truth_row <- votes_and_truth
votes_truth_row$Row <- rownames(votes_and_truth)

# see http://stackoverflow.com/questions/21618423/extract-a-dplyr-tbl-column-as-a-vector
filter(votes_truth_row, Positive==1, True==-1) %>%
  select(Row) %>%
  collect %>% .[[1]]

data[c(7766,14528,19722,20147,23042,28612),c('CHR','Nuc.Pos','REF.Nuc','ALT.Nuc','X.RS.ID','True.Label')]
# CHR   Nuc.Pos REF.Nuc ALT.Nuc    X.RS.ID True.Label
# 7766   14  62016431       A       T rs35561533         -1
# 14528  19  11348960       G       A rs12609039         -1
# 19722   1 246930564       G       C     rs7779         -1
# 20147   1  44456013       G       C rs35904809         -1
# 23042  22  45944576       T       A  rs1802787         -1
# 28612   4 166403424       T       A rs34516004         -1

# false negative
filter(votes_truth_row, Negative>0.99, True==1) %>%
  select(Row) %>%
  collect %>% .[[1]]
data[c(4015,6867,20187,22798,34844,36297,39089),c('CHR','Nuc.Pos','REF.Nuc','ALT.Nuc','X.RS.ID','True.Label')]
# CHR  Nuc.Pos REF.Nuc ALT.Nuc    X.RS.ID True.Label
# 4015   11 76853783       T       C  rs1052030          1
# 6867   13 52544715       C       A          ?          1
# 20187   1 45481018       G       A          ?          1
# 22798  22 36661906       A       G rs73885319          1
# 34844   8 21976710       T       C  rs7014851          1
# 36297   9 34649442       A       G  rs2070074          1
# 39089   X 31496398       T       C  rs1800279          1

# prediction
# values from data_subset[10,]
values <- c(0.0004286186,-0.205,0.003,10,0.83,0.0312836,0.36,-1.58,-0.462)
blah <- t(data.frame(x = values))
colnames(blah) <- features
rownames(blah) <- 10

predict(r, blah)

# read dbNSFP annotated variants

negative <- read.table('negative_dbnsfp.out', header=TRUE, stringsAsFactors=FALSE, quote='', sep="\t", comment='')
dim(negative)
# [1] 42185   452
positive <- read.table('positive_dbnsfp.out', header=TRUE, stringsAsFactors=FALSE, quote='', sep="\t", comment='')
dim(positive)
# [1] 37086   452

# http://annovar.openbioinformatics.org/en/latest/user-guide/filter/
# There are two databases for PolyPhen2: HVAR and HDIV. They are explained below:
# ljb2_pp2hvar should be used for diagnostics of Mendelian diseases, which requires distinguishing mutations with drastic effects from all the remaining human variation, including abundant mildly deleterious alleles.
# ljb2_pp2hdiv should be used when evaluating rare alleles at loci potentially involved in complex phenotypes, dense mapping of regions identified by genome-wide association studies, and analysis of natural selection from sequence data.
features_dbnsfp <- c('MutationTaster_converted_rankscore', 'MutationAssessor_score_rankscore', 'Polyphen2_HDIV_rankscore', 'Polyphen2_HVAR_rankscore', 'CADD_raw_rankscore', 'SIFT_converted_rankscore', 'LRT_converted_rankscore', 'FATHMM_converted_rankscore', 'fathmm.MKL_coding_rankscore', 'GERP.._RS_rankscore', 'phyloP100way_vertebrate_rankscore', 'phyloP20way_mammalian_rankscore')

dbnsfp_positive <- select_(positive, .dots=features_dbnsfp)
dbnsfp_positive$True.Label <- rep(1, nrow(dbnsfp_positive))

dbnsfp_negative <- select_(negative, .dots=features_dbnsfp)
dbnsfp_negative$True.Label <- rep(-1, nrow(dbnsfp_negative))

dbnsfp <- rbind(dbnsfp_positive, dbnsfp_negative)
dbnsfp$True.Label <- factor(dbnsfp$True.Label)

head(dbnsfp)
dim(dbnsfp)
# [1] 79271    13
table(dbnsfp$True.Label)
dbnsfp <- apply(dbnsfp, 2, function(x) as.numeric(gsub(x = x, pattern = '^\\.$', replacement = NA, perl = TRUE)))

# r2 <- randomForest(True.Label ~ ., data=dbnsfp, importance=TRUE, do.trace=100, na.action=na.omit, ntree=1000)

library(foreach)
library(doSNOW)
registerDoSNOW(makeCluster(10, type='SOCK'))

system.time(r2 <- foreach(ntree = rep(100, 10), .combine = combine, .multicombine=TRUE, .packages = "randomForest") %dopar%  randomForest(True.Label ~ ., data=dbnsfp, proximity=TRUE, importance=TRUE, na.action=na.omit, ntree = ntree))

varImpPlot(r2)

