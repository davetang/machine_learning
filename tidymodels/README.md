Setup
-----

Install packages.

``` {.r}
my_packages <- c('tidyverse', 'tidymodels', 'randomForest')

for (my_package in my_packages){
   if(!require(my_package, character.only = TRUE)){
      install.packages(my_package)
   }
  library(my_package, character.only = TRUE)
}

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

[Split data](https://www.tidymodels.org/start/resampling/#data-split)
using [rsample](https://rsample.tidymodels.org/).

The `initial_split()` function takes the original data and saves the
information on how to make the partitions. The `strata` argument
conducts a stratified split ensuring that our training and test data
sets will keep roughly the same proportion of classes.

``` {.r}
set.seed(1984)
spam_split <- initial_split(data = spam_data, prop = 0.8, strata = 'class')
spam_train <- training(spam_split)
spam_test <- testing(spam_split)
```

`parsnip`
---------

The [parsnip package](https://parsnip.tidymodels.org/index.html)
provides a tidy and unified interface to a range of models.

``` {.r}
my_mtry <- ceiling(sqrt(ncol(spam_data)))

rf <- list()
rand_forest(mtry = my_mtry, trees = 500) %>%
  set_engine("randomForest") %>%
  set_mode("classification") -> rf$model

rf$model %>%
  fit(class ~ ., data = spam_train) -> rf$fit

rf$model
```

    ## Random Forest Model Specification (classification)
    ## 
    ## Main Arguments:
    ##   mtry = my_mtry
    ##   trees = 500
    ## 
    ## Computational engine: randomForest

`yardstick`
-----------

The [yardstick package](https://yardstick.tidymodels.org/) provides a
tidy interface to estimate how well models are performing.

Example data to check how to prepare our data for use with `yardstick`.

``` {.r}
data(two_class_example)
str(two_class_example)
```

    ## 'data.frame':    500 obs. of  4 variables:
    ##  $ truth    : Factor w/ 2 levels "Class1","Class2": 2 1 2 1 2 1 1 1 2 2 ...
    ##  $ Class1   : num  0.00359 0.67862 0.11089 0.73516 0.01624 ...
    ##  $ Class2   : num  0.996 0.321 0.889 0.265 0.984 ...
    ##  $ predicted: Factor w/ 2 levels "Class1","Class2": 2 1 2 1 2 1 1 1 2 2 ...

``` {.r}
predict(rf$fit, spam_test, type = 'prob')
```

    ## # A tibble: 921 × 2
    ##    .pred_0 .pred_1
    ##      <dbl>   <dbl>
    ##  1   0.006   0.994
    ##  2   0.178   0.822
    ##  3   0.206   0.794
    ##  4   0.092   0.908
    ##  5   0.024   0.976
    ##  6   0.888   0.112
    ##  7   0.47    0.53 
    ##  8   0.012   0.988
    ##  9   0.022   0.978
    ## 10   0.06    0.94 
    ## # … with 911 more rows

Predict and generate table in the format of `two_class_example`.

``` {.r}
predict_wrapper <- function(fit, test_data, pos, neg, type = 'prob'){
  predict(fit, test_data, type = type) %>%
    mutate(truth = ifelse(as.integer(test_data$class) == 2, pos, neg)) %>%
    mutate(truth = factor(truth, levels = c(pos, neg))) %>%
    rename(
      ham = .pred_0,
      spam = .pred_1
    ) %>%
    mutate(
      predicted = ifelse(spam > 0.5, pos, neg)
    ) %>%
    mutate(
      predicted = factor(predicted, levels = c(pos, neg))
    ) %>%
    select(truth, everything())
}

rf$predictions <- predict_wrapper(rf$fit, spam_test, 'spam', 'ham')
rf$predictions
```

    ## # A tibble: 921 × 4
    ##    truth   ham  spam predicted
    ##    <fct> <dbl> <dbl> <fct>    
    ##  1 spam  0.006 0.994 spam     
    ##  2 spam  0.178 0.822 spam     
    ##  3 spam  0.206 0.794 spam     
    ##  4 spam  0.092 0.908 spam     
    ##  5 spam  0.024 0.976 spam     
    ##  6 spam  0.888 0.112 ham      
    ##  7 spam  0.47  0.53  spam     
    ##  8 spam  0.012 0.988 spam     
    ##  9 spam  0.022 0.978 spam     
    ## 10 spam  0.06  0.94  spam     
    ## # … with 911 more rows

Confusion matrix.

``` {.r}
cm <- table(rf$predictions$truth, rf$predictions$predicted)
cm
```

    ##       
    ##        spam ham
    ##   spam  334  29
    ##   ham    24 534

Metrics.

``` {.r}
metrics(rf$predictions, truth, predicted)
```

    ## # A tibble: 2 × 3
    ##   .metric  .estimator .estimate
    ##   <chr>    <chr>          <dbl>
    ## 1 accuracy binary         0.942
    ## 2 kap      binary         0.879

[table\_metrics](https://github.com/davetang/learning_r/blob/main/code/table_metrics.R).

``` {.r}
source("https://raw.githubusercontent.com/davetang/learning_r/main/code/table_metrics.R")
table_metrics(cm, 'spam', 'ham', 'row', sig_fig = 7)
```

    ## $accuracy
    ## [1] 0.9424539
    ## 
    ## $misclassifcation_rate
    ## [1] 0.05754615
    ## 
    ## $error_rate
    ## [1] 0.05754615
    ## 
    ## $true_positive_rate
    ## [1] 0.9201102
    ## 
    ## $sensitivity
    ## [1] 0.9201102
    ## 
    ## $recall
    ## [1] 0.9201102
    ## 
    ## $false_positive_rate
    ## [1] 0.04301075
    ## 
    ## $true_negative_rate
    ## [1] 0.9569892
    ## 
    ## $specificity
    ## [1] 0.9569892
    ## 
    ## $precision
    ## [1] 0.9329609
    ## 
    ## $prevalance
    ## [1] 0.3941368
    ## 
    ## $f1_score
    ## [1] 0.926491

Area under the PR curve.

``` {.r}
pr_auc(rf$predictions, truth, spam)
```

    ## # A tibble: 1 × 3
    ##   .metric .estimator .estimate
    ##   <chr>   <chr>          <dbl>
    ## 1 pr_auc  binary         0.987

[PR curve](https://yardstick.tidymodels.org/reference/pr_curve.html).

``` {.r}
pr_curve(rf$predictions, truth, spam) %>%
  ggplot(aes(x = recall, y = precision)) +
  geom_path() +
  coord_equal() +
  ylim(c(0, 1)) +
  ggtitle('PR curve')
```

    ## Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in
    ## dplyr 1.1.0.
    ## ℹ Please use `reframe()` instead.
    ## ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()`
    ##   always returns an ungrouped data frame and adjust accordingly.
    ## ℹ The deprecated feature was likely used in the yardstick package.
    ##   Please report the issue at <https://github.com/tidymodels/yardstick/issues>.

![](img/pr_curve-1.png)

Area under the ROC curve.

``` {.r}
roc_auc(rf$predictions, truth, spam)
```

    ## # A tibble: 1 × 3
    ##   .metric .estimator .estimate
    ##   <chr>   <chr>          <dbl>
    ## 1 roc_auc binary         0.991

[ROC curve](https://yardstick.tidymodels.org/reference/roc_curve.html).

``` {.r}
roc_curve(rf$predictions, truth, spam) %>%
  ggplot(aes(x = 1 - specificity, y = sensitivity)) +
  geom_path() +
  geom_abline(lty = 3) +
  coord_equal() +
  ggtitle('ROC curve')
```

![](img/roc_curve-1.png)

Session info
------------

Time built.

    ## [1] "2023-03-10 07:12:07 UTC"

Session info.

    ## R version 4.2.2 (2022-10-31)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 22.04.2 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so
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
    ##  [1] randomForest_4.7-1.1 yardstick_1.1.0      workflowsets_1.0.0  
    ##  [4] workflows_1.1.3      tune_1.0.1           rsample_1.1.1       
    ##  [7] recipes_1.0.5        parsnip_1.0.4        modeldata_1.1.0     
    ## [10] infer_1.0.4          dials_1.1.0          scales_1.2.1        
    ## [13] broom_1.0.3          tidymodels_1.0.0     lubridate_1.9.2     
    ## [16] forcats_1.0.0        stringr_1.5.0        dplyr_1.1.0         
    ## [19] purrr_1.0.1          readr_2.1.4          tidyr_1.3.0         
    ## [22] tibble_3.2.0         ggplot2_3.4.1        tidyverse_2.0.0     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] splines_4.2.2       foreach_1.5.2       prodlim_2019.11.13 
    ##  [4] highr_0.10          GPfit_1.0-8         yaml_2.3.7         
    ##  [7] globals_0.16.2      ipred_0.9-13        pillar_1.8.1       
    ## [10] backports_1.4.1     lattice_0.20-45     glue_1.6.2         
    ## [13] digest_0.6.31       hardhat_1.2.0       colorspace_2.1-0   
    ## [16] htmltools_0.5.4     Matrix_1.5-1        timeDate_4022.108  
    ## [19] pkgconfig_2.0.3     lhs_1.1.6           DiceDesign_1.9     
    ## [22] listenv_0.9.0       gower_1.0.1         lava_1.7.2.1       
    ## [25] tzdb_0.3.0          timechange_0.2.0    farver_2.1.1       
    ## [28] generics_0.1.3      ellipsis_0.3.2      withr_2.5.0        
    ## [31] furrr_0.3.1         nnet_7.3-18         cli_3.6.0          
    ## [34] survival_3.4-0      magrittr_2.0.3      evaluate_0.20      
    ## [37] future_1.32.0       fansi_1.0.4         parallelly_1.34.0  
    ## [40] MASS_7.3-58.1       class_7.3-20        tools_4.2.2        
    ## [43] hms_1.1.2           lifecycle_1.0.3     munsell_0.5.0      
    ## [46] compiler_4.2.2      rlang_1.0.6         grid_4.2.2         
    ## [49] rstudioapi_0.14     iterators_1.0.14    labeling_0.4.2     
    ## [52] rmarkdown_2.20      gtable_0.3.1        codetools_0.2-18   
    ## [55] R6_2.5.1            knitr_1.42          fastmap_1.1.1      
    ## [58] future.apply_1.10.0 utf8_1.2.3          stringi_1.7.12     
    ## [61] parallel_4.2.2      Rcpp_1.0.10         vctrs_0.5.2        
    ## [64] rpart_4.1.19        tidyselect_1.2.0    xfun_0.37
