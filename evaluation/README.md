Introduction
------------

Different performance measures for evaluating predictive models and
unsupervised clustering.

Install packages if missing and load.

``` {.r}
.libPaths('/packages')
my_packages <- c('caret', 'clValid', 'dendextend', 'rpart', 'ROCR', 'randomForest', 'verification')

for (my_package in my_packages){
   if(!require(my_package, character.only = TRUE)){
      install.packages(my_package, '/packages')
      library(my_package, character.only = TRUE)
   }
}
library(tidyverse)
theme_set(theme_bw())
```

Spam
----

Use [spam
data](https://archive.ics.uci.edu/ml/machine-learning-databases/spambase/spambase.names)
to train a Random Forest model to illustrate evaluation measures. Class
0 and 1 are ham (non-spam) and spam, respectively.

``` {.r}
spam_data <- read.csv(file = "../data/spambase.csv")
spam_data$class <- factor(spam_data$class)

spam_data[c(1:3, (nrow(spam_data)-2):nrow(spam_data)), (ncol(spam_data)-2):ncol(spam_data)]
```

    ##      capital_run_length_longest capital_run_length_total class
    ## 1                            61                      278     1
    ## 2                           101                     1028     1
    ## 3                           485                     2259     1
    ## 4599                          6                      118     0
    ## 4600                          5                       78     0
    ## 4601                          5                       40     0

Train model.

``` {.r}
set.seed(31)
system.time(rf <- randomForest(class ~ ., data = spam_data, importance=TRUE, proximity=TRUE, do.trace=100))
```

    ## ntree      OOB      1      2
    ##   100:   4.76%  3.16%  7.23%
    ##   200:   4.65%  2.80%  7.50%
    ##   300:   4.65%  2.73%  7.61%
    ##   400:   4.63%  2.73%  7.56%
    ##   500:   4.59%  2.73%  7.45%

    ##    user  system elapsed 
    ##  30.247   0.682  31.004

Classification measures
-----------------------

Build confusion matrix and calculate accuracy, precision, and recall.
Check out [this guide as
well](https://www.dataschool.io/simple-guide-to-confusion-matrix-terminology/).

![Confusion matrix](img/confusion_matrix.png)

Use `table` to construct a confusion matrix, where rows are real labels
and columns are the predictions (different from the table above).
Therefore the first row and first column cell are the non-spam cases
that were predicted as non-spam (true negative). The first row and
second column cell are the non-spam cases predicted as spam (false
positive). The second row and first column cell are spam cases predicted
as non-spam (false negative). Finally, the second row and second column
cell are cases that are spam and predicted as spam (true positive).

``` {.r}
(spam_rf_table <- table(spam_data$class, rf$predicted))
```

    ##    
    ##        0    1
    ##   0 2712   76
    ##   1  135 1678

``` {.r}
TN <- spam_rf_table[1, 1]
FP <- spam_rf_table[1, 2]
FN <- spam_rf_table[2, 1]
TP <- spam_rf_table[2, 2]
```

Accuracy is the easiest to remember; you take all the correct
predictions and divide by the total:

-   Accuracy = (TP + TN) / (TP + FP + FN + TN)

``` {.r}
(accuracy <- (TP + TN) / (TP + FN + FP + TN))
```

    ## [1] 0.9541404

``` {.r}
(accuracy  <- sum(diag(spam_rf_table)) / sum(spam_rf_table))
```

    ## [1] 0.9541404

Precision or Positive Predictive Value (PPV) is concerned with all the
*positive* calls that were *predicted* (column two of our table):

-   Precision or Positive Predictive Value (PPV) = TP / (TP + FP)

``` {.r}
(precision <- TP / (TP + FP))
```

    ## [1] 0.9566705

Recall (also known by other names, see below) is concerned with how many
of the *truth positive cases* were predicted as positive (row two of our
table). The term sensitivity makes a bit more sense to me as it
describes how sensitive a method is in detecting positive cases.

-   Sensitivity or True Positive Rate (TPR) or Recall or Hit Rate = TP /
    (TP + FN)

``` {.r}
(recall <- TP / (TP + FN))
```

    ## [1] 0.9255378

Specificity is concerned with how many of the *truth negative cases*
were predicted as negative (row one of our table), which is opposite to
sensitivity.

-   Specificity or True Negative Rate (TNR) = TN / (TN + FP)

``` {.r}
(specificity <- TN / (TN + FP))
```

    ## [1] 0.9727403

-   Fall-out or False Positive Rate (FPR) = FP / (FP + TN) = 1 -
    specificity

``` {.r}
(false_positive_rate <- FP / (FP + TN))
```

    ## [1] 0.02725968

``` {.r}
(1 - specificity)
```

    ## [1] 0.02725968

-   Negative Predictive Value (NPV) = TN / (TN + FN)

``` {.r}
(npv <- TN / (TN + FN))
```

    ## [1] 0.9525817

-   False Discovery Rate (FDR) = FP / (TP + FP) = 1 - PPV

``` {.r}
(fdr <- FP / (TP + FP))
```

    ## [1] 0.04332953

``` {.r}
(1 - precision)
```

    ## [1] 0.04332953

-   False Negative Rate (FNR) = FN / (FN + TP) = 1 - TPR

``` {.r}
(fnr <- FN / (FN + TP))
```

    ## [1] 0.07446222

``` {.r}
(1 - recall)
```

    ## [1] 0.07446222

Depending on the application, different metrics can be more desirable
than others. For example when detecting spam, it is more preferably to
have a high specificity (detect all real emails) than to have a high
sensitivity (detect all spam).

Regression
----------

Root Mean Squared Error (RMSE), which is the mean distance between
estimates and the regression line.

![](https://latex.codecogs.com/png.image?\large&space;\dpi%7B110%7D\bg%7Bwhite%7DRMSE&space;=&space;\sqrt%7B&space;\frac%7B1%7D%7BN%7D&space;\sum_%7Bi=1%7D%5E%7BN%7D&space;(y_i&space;-&space;\hat%7By%7D_i)%5E2&space;%7D)

The blue line and black lines in the plot below shows the linear fit and
the residuals (how far off a prediction was from the actual value),
respectively. The RMSE sums all squared residuals, divides by all cases
(i.e. calculates the mean), and then takes the square root.

![Root Mean Squared Error (RMSE)](img/rmse.png)

We can calculate the RMSE as per below.

``` {.r}
# predict height from weight
lm.fit <- lm(height ~ weight, data = women)
h_pred <- predict(lm.fit, women)
(rmse <- sqrt( ( 1/length(h_pred) ) * sum( (women$height - h_pred) ^ 2) ))
```

    ## [1] 0.4096541

Clustering
----------

Measure the distance between points within a cluster and between
clusters. Perform k-means to demonstrate.

``` {.r}
km <- kmeans(iris[,-5], centers = 3, nstart = 1)
```

Within Sum of Squares (WSS) measures the within cluster similarity

``` {.r}
km$withinss
```

    ## [1] 23.87947 39.82097 15.15100

Between cluster Sum of Squares (BSS) measures the between cluster
similarity

``` {.r}
km$betweenss
```

    ## [1] 602.5192

The [Dunn index](https://en.wikipedia.org/wiki/Dunn_index) is the
minimal intercluster distance (between cluster measurement) divided by
the maximal diameter (within cluster measurement); a higher Dunn index
indicates better clustering.

``` {.r}
d  <- dist(iris[,-5])
dunn(d, km$cluster)
```

    ## [1] 0.09880739

Perform hierarchical clustering and cut dendrogram to form three
clusters (example adapted from `clValid`).

``` {.r}
data(mouse, package = "clValid")
express <- mouse[1:25, -c(1,8)]
rownames(express) <- mouse$ID[1:25]
express_dist <- dist(express, method="euclidean")
express_hclust <- hclust(express_dist, method="average")
express_cluster <- cutree(express_hclust, k = 3)
dunn(express_dist, express_cluster)
```

    ## [1] 0.2315126

Hierarchical clustering.

``` {.r}
plot(color_branches(express_hclust, k = 3))
```

![](img/dendrogram-1.png)

Not sure that a higher Dunn index indicates better clustering.

``` {.r}
my_dunn <- vector()
i <- 1
min_k <- 3
max_k <- nrow(express)-1
for (k in min_k:max_k){
  my_clust <- cutree(express_hclust, k = k)
  my_dunn[i] <- dunn(express_dist, my_clust)
  i <- i + 1
}
names(my_dunn) <- min_k:max_k

barplot(
  my_dunn,
  main = "Dunn index at different cluster numbers",
  las = 2
)
```

![](img/try_k-1.png)

Cross validation
----------------

Instead of a single instance of train/test, cross validation carries out
n-fold train/test evaluations. For example, the example below
illustrates a 4-fold cross validation.

![4 fold cross validation](img/cross_validation.png)

The `caret` package in R supports many types of cross-validation, and
you can specify which type of cross-validation and the number of
cross-validation folds with the trainControl() function, which you pass
to the trControl argument in train().

``` {.r}
# using the diamonds data set from ggplot2
# ggplot2 is automatically loaded with caret
model <- train(
  price ~ ., diamonds,
  method = "lm",
  trControl = trainControl(
    method = "cv",
    number = 10,
    verboseIter = TRUE
  )
)
```

    ## + Fold01: intercept=TRUE 
    ## - Fold01: intercept=TRUE 
    ## + Fold02: intercept=TRUE 
    ## - Fold02: intercept=TRUE 
    ## + Fold03: intercept=TRUE 
    ## - Fold03: intercept=TRUE 
    ## + Fold04: intercept=TRUE 
    ## - Fold04: intercept=TRUE 
    ## + Fold05: intercept=TRUE 
    ## - Fold05: intercept=TRUE 
    ## + Fold06: intercept=TRUE 
    ## - Fold06: intercept=TRUE 
    ## + Fold07: intercept=TRUE 
    ## - Fold07: intercept=TRUE 
    ## + Fold08: intercept=TRUE 
    ## - Fold08: intercept=TRUE 
    ## + Fold09: intercept=TRUE 
    ## - Fold09: intercept=TRUE 
    ## + Fold10: intercept=TRUE 
    ## - Fold10: intercept=TRUE 
    ## Aggregating results
    ## Fitting final model on full training set

``` {.r}
model
```

    ## Linear Regression 
    ## 
    ## 53940 samples
    ##     9 predictor
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (10 fold) 
    ## Summary of sample sizes: 48547, 48547, 48546, 48547, 48545, 48545, ... 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared   MAE     
    ##   1130.808  0.9196786  740.3986
    ## 
    ## Tuning parameter 'intercept' was held constant at a value of TRUE

Using the `caret` package, you can perform 5 x 5-fold cross validations
by adding the `repeats` parameter.

``` {.r}
model <- train(
  price ~ ., diamonds,
  method = "lm",
  trControl = trainControl(
    method = "cv",
    number = 5,
    repeats = 5,
    verboseIter = TRUE
  )
)
```

    ## Warning: `repeats` has no meaning for this resampling method.

    ## + Fold1: intercept=TRUE 
    ## - Fold1: intercept=TRUE 
    ## + Fold2: intercept=TRUE 
    ## - Fold2: intercept=TRUE 
    ## + Fold3: intercept=TRUE 
    ## - Fold3: intercept=TRUE 
    ## + Fold4: intercept=TRUE 
    ## - Fold4: intercept=TRUE 
    ## + Fold5: intercept=TRUE 
    ## - Fold5: intercept=TRUE 
    ## Aggregating results
    ## Fitting final model on full training set

``` {.r}
model
```

    ## Linear Regression 
    ## 
    ## 53940 samples
    ##     9 predictor
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 43152, 43152, 43152, 43152, 43152 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared   MAE     
    ##   1131.282  0.9195997  740.5735
    ## 
    ## Tuning parameter 'intercept' was held constant at a value of TRUE

Receiver Operator Characteristic Curve
--------------------------------------

The
[ROCR](https://cran.rstudio.com/web/packages/ROCR/vignettes/ROCR.html)
package can be used to generate ROC curves, which has the False Positive
Rate (FP / \[FP + TN\]) on the x-axis and the True Positive Rate (TP /
\[TP + FN\]) on the y-axis.

The point of the ROC curve is to find the best probability to use
maximising the True Positive Rate at the lowest False Positive rate. We
will use the spam data again and we will start with a random predictor
to illustrate how a ROC curve looks with a random predictor.

``` {.r}
spam_data <- read.csv(file = "../data/spambase.csv")
spam_data$class <- factor(spam_data$class)

set.seed(1984)
random_prob <- runif(n = nrow(spam_data))
pred <- prediction(random_prob, spam_data$class)

auc <- performance(pred, 'auc')
auc_value <- round(auc@y.values[[1]], 4)

perf <- performance(pred, 'tpr', 'fpr')
plot(perf, main='ROC for random predictor of spam')
legend('bottomright', legend = paste('AUC = ', auc_value))
```

![](img/random_predictor-1.png)

Let's train a random forest model and use the votes as the probability.

``` {.r}
set.seed(1984)
system.time(rf <- randomForest(class ~ ., data = spam_data))
```

    ##    user  system elapsed 
    ##   7.499   0.148   7.665

``` {.r}
pred <- prediction(rf$votes[, 2], spam_data$class)
auc <- performance(pred, 'auc')
auc_value <- round(auc@y.values[[1]], 4)

perf <- performance(pred, 'tpr', 'fpr')
plot(
  perf,
  main='ROC for Random Forests classifier of spam',
  colorize = TRUE,
  lwd = 3
)
legend("bottomright", legend = paste('AUC = ', auc_value))
```

![](img/random_forest_roc-1.png)

The [verification
package](https://cran.r-project.org/web/packages/verification/index.html)
can also be used to generate a (nicer looking) ROC curve.

``` {.r}
labels <- as.integer(spam_data$class == 1)
probs <- rf$votes[, 2]
auc <- roc.area(labels, probs)$A
roc.plot(labels, probs, main="OOB ROC Curve", threshold = seq(0, 1, 0.1))
legend("bottomright", bty="n", sprintf("Area Under the Curve (AUC) = %1.4f", auc))
```

![](img/roc_verification-1.png)

Plotting with confidence intervals, which are calculated by
bootstrapping the observations and prediction, then calculating
probability of detection yes (PODy) and probability of detection no
(PODn) values. The default CI is 95%.

``` {.r}
system.time(
  roc.plot(labels, probs, main="OOB ROC Curve", threshold = seq(0, 1, 0.1), CI = TRUE)
)
```

    ##    user  system elapsed 
    ##  10.159   0.095  10.279

``` {.r}
legend("bottomright", bty="n", sprintf("Area Under the Curve (AUC) = %1.4f", auc))
```

![](img/roc_verification_ci-1.png)

Precision (TP / \[TP + FP\]) Recall (TP / \[TP + FN\]).

``` {.r}
pred <- prediction(rf$votes[, 2], spam_data$class)
perf <- performance(pred, "prec", "rec")
auc <- performance(pred, "aucpr")
auc_value <- round(auc@y.values[[1]], 4)

plot(perf,
     avg= "threshold",
     colorize=TRUE,
     lwd= 3,
     main= "Precision/Recall"
)
legend('bottomleft', legend = paste('AUC = ', auc_value))
```

![](img/precision_recall-1.png)

Session info
------------

Time built.

    ## [1] "2022-11-04 07:37:42 UTC"

Session info.

    ## R version 4.2.1 (2022-06-23)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 20.04.4 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/liblapack.so.3
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] forcats_0.5.1        stringr_1.4.0        dplyr_1.0.9         
    ##  [4] purrr_0.3.4          readr_2.1.2          tidyr_1.2.0         
    ##  [7] tibble_3.1.7         tidyverse_1.3.1      verification_1.42   
    ## [10] dtw_1.22-3           proxy_0.4-27         CircStats_0.2-6     
    ## [13] MASS_7.3-57          boot_1.3-28          fields_14.0         
    ## [16] viridis_0.6.2        viridisLite_0.4.0    spam_2.8-0          
    ## [19] randomForest_4.7-1.1 ROCR_1.0-11          rpart_4.1.16        
    ## [22] dendextend_1.16.0    clValid_0.7          cluster_2.1.3       
    ## [25] caret_6.0-92         lattice_0.20-45      ggplot2_3.3.6       
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] nlme_3.1-157         fs_1.5.2             lubridate_1.8.0     
    ##  [4] httr_1.4.3           tools_4.2.1          backports_1.4.1     
    ##  [7] utf8_1.2.2           R6_2.5.1             DBI_1.1.3           
    ## [10] colorspace_2.0-3     nnet_7.3-17          withr_2.5.0         
    ## [13] tidyselect_1.1.2     gridExtra_2.3        compiler_4.2.1      
    ## [16] rvest_1.0.2          cli_3.3.0            xml2_1.3.3          
    ## [19] scales_1.2.0         digest_0.6.29        rmarkdown_2.14      
    ## [22] pkgconfig_2.0.3      htmltools_0.5.2      parallelly_1.32.0   
    ## [25] highr_0.9            dbplyr_2.2.1         fastmap_1.1.0       
    ## [28] maps_3.4.0           readxl_1.4.0         rlang_1.0.3         
    ## [31] rstudioapi_0.13      generics_0.1.3       jsonlite_1.8.0      
    ## [34] ModelMetrics_1.2.2.2 magrittr_2.0.3       dotCall64_1.0-1     
    ## [37] Matrix_1.4-1         Rcpp_1.0.8.3         munsell_0.5.0       
    ## [40] fansi_1.0.3          lifecycle_1.0.1      stringi_1.7.6       
    ## [43] pROC_1.18.0          yaml_2.3.5           plyr_1.8.7          
    ## [46] recipes_1.0.1        grid_4.2.1           parallel_4.2.1      
    ## [49] listenv_0.8.0        crayon_1.5.1         haven_2.5.0         
    ## [52] splines_4.2.1        hms_1.1.1            knitr_1.39          
    ## [55] pillar_1.7.0         future.apply_1.9.0   reshape2_1.4.4      
    ## [58] codetools_0.2-18     stats4_4.2.1         reprex_2.0.1        
    ## [61] glue_1.6.2           evaluate_0.15        modelr_0.1.8        
    ## [64] data.table_1.14.2    tzdb_0.3.0           vctrs_0.4.1         
    ## [67] foreach_1.5.2        cellranger_1.1.0     gtable_0.3.0        
    ## [70] future_1.26.1        assertthat_0.2.1     xfun_0.31           
    ## [73] gower_1.0.0          prodlim_2019.11.13   broom_1.0.0         
    ## [76] class_7.3-20         survival_3.3-1       timeDate_3043.102   
    ## [79] iterators_1.0.14     hardhat_1.2.0        lava_1.6.10         
    ## [82] globals_0.15.1       ellipsis_0.3.2       ipred_0.9-13
