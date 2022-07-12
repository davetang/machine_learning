Introduction
------------

A support vector machine (SVM) is a supervised machine learning
algorithm that can be used for classification and regression. The
essence of SVM classification is broken down into four main concepts:

-   The separating hyperplane (a plane that can separate cases into
    their respective classes)
-   The maximum-margin hyperplane or maximum-margin linear discriminants
    (the hyperplane that has maximal distance from the different
    classes)

![Example of the maximum-margin
hyperplane](img/SVM_Example_of_Hyperplanes.png)

-   The soft margin (allowing cases from another class to fall into the
    opposite class)
-   The kernel function (adding an additional dimension)

SVMs rely on preprocessing the data to represent patterns in a high
dimension using a kernel function, typically much higher than the
original feature space.

In essence, the kernel function is a mathematical trick that allows the
SVM to perform a "two-dimensional" classification of a set of originally
one-dimensional data. In general, a kernel function projects data from a
low-dimensional space to a space of higher dimension. It is possible to
prove that, for any given data set with consistent labels (where
consistent simply means that the data set does not contain two identical
objects with opposite labels) there exists a kernel function that will
allow the data to be linearly separated ([Noble, Nature Biotechnology
2006](https://www.ncbi.nlm.nih.gov/pubmed/17160063)).

Using a hyperplane from an SVM that uses a very high-dimensional kernel
function will result in overfitting. An optimal kernel function can be
selected from a fixed set of kernels in a statistically rigorous fashion
by using cross-validation. Kernels also allow us to combine different
data sets.

Install packages if missing and load.

``` {.r}
.libPaths('/packages')
my_packages <- 'e1071'

for (my_package in my_packages){
   if(!require(my_package, character.only = TRUE)){
      install.packages(my_package, '/packages')
      library(my_package, character.only = TRUE)
   }
}
```

Breast cancer data
------------------

Using the [Breast Cancer Wisconsin (Diagnostic) Data
Set](http://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)).

``` {.r}
data <- read.table("../data/breast_cancer_data.csv", stringsAsFactors = FALSE, sep = ',', header = TRUE)
```

The class should be a factor; 2 is benign and 4 is malignant.

``` {.r}
data$class <- factor(data$class)
```

Finally remove id column.

``` {.r}
data <- data[,-1]
```

Separate into training (80%) and testing (20%).

``` {.r}
set.seed(31)
my_decider <- rbinom(n=nrow(data),size=1,p=0.8)
table(my_decider)
```

    ## my_decider
    ##   0   1 
    ## 122 477

``` {.r}
train <- data[as.logical(my_decider),]
test <- data[!as.logical(my_decider),]
```

Using the `e1071` package.

``` {.r}
tuned <- tune.svm(class ~ ., data = train, gamma = 10^(-6:-1), cost = 10^(-1:1))
summary(tuned)
```

    ## 
    ## Parameter tuning of 'svm':
    ## 
    ## - sampling method: 10-fold cross validation 
    ## 
    ## - best parameters:
    ##  gamma cost
    ##   0.01    1
    ## 
    ## - best performance: 0.03554965 
    ## 
    ## - Detailed performance results:
    ##    gamma cost      error dispersion
    ## 1  1e-06  0.1 0.38151596 0.07135654
    ## 2  1e-05  0.1 0.38151596 0.07135654
    ## 3  1e-04  0.1 0.38151596 0.07135654
    ## 4  1e-03  0.1 0.36471631 0.07013290
    ## 5  1e-02  0.1 0.04184397 0.02770554
    ## 6  1e-01  0.1 0.03767730 0.02146151
    ## 7  1e-06  1.0 0.38151596 0.07135654
    ## 8  1e-05  1.0 0.38151596 0.07135654
    ## 9  1e-04  1.0 0.36471631 0.07013290
    ## 10 1e-03  1.0 0.03971631 0.02845194
    ## 11 1e-02  1.0 0.03554965 0.02197298
    ## 12 1e-01  1.0 0.03559397 0.02203474
    ## 13 1e-06 10.0 0.38151596 0.07135654
    ## 14 1e-05 10.0 0.36263298 0.06657450
    ## 15 1e-04 10.0 0.03971631 0.02845194
    ## 16 1e-03 10.0 0.03554965 0.02197298
    ## 17 1e-02 10.0 0.03971631 0.02670322
    ## 18 1e-01 10.0 0.05447695 0.02631057

Train model using the best values for gamma and cost.

``` {.r}
svm_model <- svm(class ~ ., data = train, kernel="radial", gamma=0.01, cost=1)
summary(svm_model)
```

    ## 
    ## Call:
    ## svm(formula = class ~ ., data = train, kernel = "radial", gamma = 0.01, 
    ##     cost = 1)
    ## 
    ## 
    ## Parameters:
    ##    SVM-Type:  C-classification 
    ##  SVM-Kernel:  radial 
    ##        cost:  1 
    ## 
    ## Number of Support Vectors:  72
    ## 
    ##  ( 36 36 )
    ## 
    ## 
    ## Number of Classes:  2 
    ## 
    ## Levels: 
    ##  2 4

Predict test cases.

``` {.r}
svm_predict <- predict(svm_model, test)
table(svm_predict, test$class)
```

    ##            
    ## svm_predict  2  4
    ##           2 77  2
    ##           4  2 41

Further reading
---------------

-   [Data Mining Algorithms In
    R/Classification/SVM](https://en.wikibooks.org/wiki/Data_Mining_Algorithms_In_R/Classification/SVM)

Session info
------------

Time built.

    ## [1] "2022-07-12 05:57:27 UTC"

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
    ##  [1] e1071_1.7-11    forcats_0.5.1   stringr_1.4.0   dplyr_1.0.9    
    ##  [5] purrr_0.3.4     readr_2.1.2     tidyr_1.2.0     tibble_3.1.7   
    ##  [9] ggplot2_3.3.6   tidyverse_1.3.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.2 xfun_0.31        haven_2.5.0      colorspace_2.0-3
    ##  [5] vctrs_0.4.1      generics_0.1.3   htmltools_0.5.2  yaml_2.3.5      
    ##  [9] utf8_1.2.2       rlang_1.0.3      pillar_1.7.0     glue_1.6.2      
    ## [13] withr_2.5.0      DBI_1.1.3        dbplyr_2.2.1     modelr_0.1.8    
    ## [17] readxl_1.4.0     lifecycle_1.0.1  munsell_0.5.0    gtable_0.3.0    
    ## [21] cellranger_1.1.0 rvest_1.0.2      evaluate_0.15    knitr_1.39      
    ## [25] tzdb_0.3.0       fastmap_1.1.0    class_7.3-20     fansi_1.0.3     
    ## [29] broom_1.0.0      scales_1.2.0     backports_1.4.1  jsonlite_1.8.0  
    ## [33] fs_1.5.2         hms_1.1.1        digest_0.6.29    stringi_1.7.6   
    ## [37] grid_4.2.1       cli_3.3.0        tools_4.2.1      magrittr_2.0.3  
    ## [41] proxy_0.4-27     crayon_1.5.1     pkgconfig_2.0.3  ellipsis_0.3.2  
    ## [45] xml2_1.3.3       reprex_2.0.1     lubridate_1.8.0  rstudioapi_0.13 
    ## [49] assertthat_0.2.1 rmarkdown_2.14   httr_1.4.3       R6_2.5.1        
    ## [53] compiler_4.2.1
