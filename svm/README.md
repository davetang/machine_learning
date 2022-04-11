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
SVM to perform a “two-dimensional” classification of a set of originally
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

    .libPaths('/packages')
    my_packages <- 'e1071'

    for (my_package in my_packages){
       if(!require(my_package, character.only = TRUE)){
          install.packages(my_package, '/packages')
          library(my_package, character.only = TRUE)
       }
    }

Breast cancer data
------------------

Using the [Breast Cancer Wisconsin (Diagnostic) Data
Set](http://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)).

    my_link <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data'
    data <- read.table(url(my_link), stringsAsFactors = FALSE, header = FALSE, sep = ',')
    names(data) <- c('id','ct','ucsize','ucshape','ma','secs','bn','bc','nn','miti','class')
    head(data)

    ##        id ct ucsize ucshape ma secs bn bc nn miti class
    ## 1 1000025  5      1       1  1    2  1  3  1    1     2
    ## 2 1002945  5      4       4  5    7 10  3  2    1     2
    ## 3 1015425  3      1       1  1    2  2  3  1    1     2
    ## 4 1016277  6      8       8  1    3  4  3  7    1     2
    ## 5 1017023  4      1       1  3    2  1  3  1    1     2
    ## 6 1017122  8     10      10  8    7 10  9  7    1     4

Any missing data?

    dim(data)[1] * dim(data)[2]

    ## [1] 7689

    table(is.na.data.frame(data))

    ## 
    ## FALSE 
    ##  7689

What’s the structure?

    str(data)

    ## 'data.frame':    699 obs. of  11 variables:
    ##  $ id     : int  1000025 1002945 1015425 1016277 1017023 1017122 1018099 1018561 1033078 1033078 ...
    ##  $ ct     : int  5 5 3 6 4 8 1 2 2 4 ...
    ##  $ ucsize : int  1 4 1 8 1 10 1 1 1 2 ...
    ##  $ ucshape: int  1 4 1 8 1 10 1 2 1 1 ...
    ##  $ ma     : int  1 5 1 1 3 8 1 1 1 1 ...
    ##  $ secs   : int  2 7 2 3 2 7 2 2 2 2 ...
    ##  $ bn     : chr  "1" "10" "2" "4" ...
    ##  $ bc     : int  3 3 3 3 3 9 3 3 1 2 ...
    ##  $ nn     : int  1 2 1 7 1 7 1 1 1 1 ...
    ##  $ miti   : int  1 1 1 1 1 1 1 1 5 1 ...
    ##  $ class  : int  2 2 2 2 2 4 2 2 2 2 ...

Why is the bare nuclei (bn) stored as characters instead of integers?

    table(data$bn)

    ## 
    ##   ?   1  10   2   3   4   5   6   7   8   9 
    ##  16 402 132  30  28  19  30   4   8  21   9

Change the question marks into NA’s and then into median values.

    data$bn <- gsub(pattern = '\\?', replacement = NA, x = data$bn)
    data$bn <- as.integer(data$bn)
    my_median <- median(data$bn, na.rm = TRUE)
    data$bn[is.na(data$bn)] <- my_median
    str(data)

    ## 'data.frame':    699 obs. of  11 variables:
    ##  $ id     : int  1000025 1002945 1015425 1016277 1017023 1017122 1018099 1018561 1033078 1033078 ...
    ##  $ ct     : int  5 5 3 6 4 8 1 2 2 4 ...
    ##  $ ucsize : int  1 4 1 8 1 10 1 1 1 2 ...
    ##  $ ucshape: int  1 4 1 8 1 10 1 2 1 1 ...
    ##  $ ma     : int  1 5 1 1 3 8 1 1 1 1 ...
    ##  $ secs   : int  2 7 2 3 2 7 2 2 2 2 ...
    ##  $ bn     : int  1 10 2 4 1 10 10 1 1 1 ...
    ##  $ bc     : int  3 3 3 3 3 9 3 3 1 2 ...
    ##  $ nn     : int  1 2 1 7 1 7 1 1 1 1 ...
    ##  $ miti   : int  1 1 1 1 1 1 1 1 5 1 ...
    ##  $ class  : int  2 2 2 2 2 4 2 2 2 2 ...

The class should be a factor; 2 is benign and 4 is malignant.

    data$class <- factor(data$class)

Finally remove id the row name, which was not unique anyway.

    data <- data[,-1]

Separate into training (80%) and testing (20%).

    set.seed(31)
    my_decider <- rbinom(n=nrow(data),size=1,p=0.8)
    table(my_decider)

    ## my_decider
    ##   0   1 
    ## 151 548

    train <- data[as.logical(my_decider),]
    test <- data[!as.logical(my_decider),]

Using the `e1071` package.

    tuned <- tune.svm(class ~ ., data = train, gamma = 10^(-6:-1), cost = 10^(-1:1))
    summary(tuned)

    ## 
    ## Parameter tuning of 'svm':
    ## 
    ## - sampling method: 10-fold cross validation 
    ## 
    ## - best parameters:
    ##  gamma cost
    ##    0.1    1
    ## 
    ## - best performance: 0.02555556 
    ## 
    ## - Detailed performance results:
    ##    gamma cost      error dispersion
    ## 1  1e-06  0.1 0.34319865 0.04711347
    ## 2  1e-05  0.1 0.34319865 0.04711347
    ## 3  1e-04  0.1 0.34319865 0.04711347
    ## 4  1e-03  0.1 0.31767677 0.04681231
    ## 5  1e-02  0.1 0.03468013 0.02184491
    ## 6  1e-01  0.1 0.03282828 0.01876498
    ## 7  1e-06  1.0 0.34319865 0.04711347
    ## 8  1e-05  1.0 0.34319865 0.04711347
    ## 9  1e-04  1.0 0.31767677 0.04681231
    ## 10 1e-03  1.0 0.03468013 0.02009323
    ## 11 1e-02  1.0 0.02734007 0.02604193
    ## 12 1e-01  1.0 0.02555556 0.02302315
    ## 13 1e-06 10.0 0.34319865 0.04711347
    ## 14 1e-05 10.0 0.31767677 0.04681231
    ## 15 1e-04 10.0 0.03468013 0.02009323
    ## 16 1e-03 10.0 0.02734007 0.02604193
    ## 17 1e-02 10.0 0.03286195 0.02818789
    ## 18 1e-01 10.0 0.04016835 0.02548171

Train model using the best values for gamma and cost.

    svm_model <- svm(class ~ ., data = train, kernel="radial", gamma=0.01, cost=1)
    summary(svm_model)

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
    ## Number of Support Vectors:  74
    ## 
    ##  ( 37 37 )
    ## 
    ## 
    ## Number of Classes:  2 
    ## 
    ## Levels: 
    ##  2 4

Predict test cases.

    svm_predict <- predict(svm_model, test)
    table(svm_predict, test$class)

    ##            
    ## svm_predict  2  4
    ##           2 95  5
    ##           4  3 48

Further reading
---------------

-   [Data Mining Algorithms In
    R/Classification/SVM](https://en.wikibooks.org/wiki/Data_Mining_Algorithms_In_R/Classification/SVM)

Session info
------------

Time built.

    ## [1] "2022-04-11 01:25:00 UTC"

Session info.

    ## R version 4.1.3 (2022-03-10)
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
    ##  [1] e1071_1.7-9     forcats_0.5.1   stringr_1.4.0   dplyr_1.0.8    
    ##  [5] purrr_0.3.4     readr_2.1.2     tidyr_1.2.0     tibble_3.1.6   
    ##  [9] ggplot2_3.3.5   tidyverse_1.3.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.2 xfun_0.30        haven_2.4.3      colorspace_2.0-3
    ##  [5] vctrs_0.4.0      generics_0.1.2   htmltools_0.5.2  yaml_2.3.5      
    ##  [9] utf8_1.2.2       rlang_1.0.2      pillar_1.7.0     glue_1.6.2      
    ## [13] withr_2.5.0      DBI_1.1.2        dbplyr_2.1.1     modelr_0.1.8    
    ## [17] readxl_1.4.0     lifecycle_1.0.1  munsell_0.5.0    gtable_0.3.0    
    ## [21] cellranger_1.1.0 rvest_1.0.2      evaluate_0.15    knitr_1.38      
    ## [25] tzdb_0.3.0       fastmap_1.1.0    class_7.3-20     fansi_1.0.3     
    ## [29] broom_0.7.12     scales_1.1.1     backports_1.4.1  jsonlite_1.8.0  
    ## [33] fs_1.5.2         hms_1.1.1        digest_0.6.29    stringi_1.7.6   
    ## [37] grid_4.1.3       cli_3.2.0        tools_4.1.3      magrittr_2.0.3  
    ## [41] proxy_0.4-26     crayon_1.5.1     pkgconfig_2.0.3  ellipsis_0.3.2  
    ## [45] xml2_1.3.3       reprex_2.0.1     lubridate_1.8.0  rstudioapi_0.13 
    ## [49] assertthat_0.2.1 rmarkdown_2.13   httr_1.4.2       R6_2.5.1        
    ## [53] compiler_4.1.3
