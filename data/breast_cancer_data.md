Using the [Breast Cancer Wisconsin (Diagnostic) Data
Set](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)).

    my_link <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data'
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

    any(is.na(data))

    ## [1] FALSE

Data structure.

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

Bare nuclei (`bn`) was stored as characters because of question marks.

    table(data$bn)

    ## 
    ##   ?   1  10   2   3   4   5   6   7   8   9 
    ##  16 402 132  30  28  19  30   4   8  21   9

Change the question marks into NA’s and then into median values.

    data$bn <- as.integer(gsub(pattern = '\\?', replacement = NA, x = data$bn))

    data$bn[is.na(data$bn)] <- median(data$bn, na.rm = TRUE)

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

Convert `class` into a factor with levels `2` for benign and `4` for
malignant.

    data$class <- factor(data$class)

The `id` column is duplicated and it is not clear why they are
duplicated.

    dup_idx <- which(duplicated(data$id))
    dup_data <- data[data$id %in% data[dup_idx, 'id'], ]

    head(dup_data[order(dup_data$id), ])

    ##         id ct ucsize ucshape ma secs bn bc nn miti class
    ## 268 320675  3      3       5  2    3 10  7  1    1     4
    ## 273 320675  3      3       5  2    3 10  7  1    1     4
    ## 270 385103  1      1       1  1    2  1  3  1    1     2
    ## 576 385103  5      1       2  1    2  1  3  1    1     2
    ## 272 411453  5      1       1  1    2  1  3  1    1     2
    ## 608 411453  1      1       1  1    2  1  1  1    1     2

We will remove duplicated IDs.

    dim(data)

    ## [1] 699  11

    data <- data[! data$id %in% data[dup_idx, 'id'], ]

    dim(data)

    ## [1] 599  11

    write.csv(
      x = data,
      file = "breast_cancer_data.csv",
      quote = FALSE,
      row.names = FALSE
    )

Session info
------------

Time built.

    ## [1] "2022-04-11 03:40:46 UTC"

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
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.1.3  magrittr_2.0.3  fastmap_1.1.0   cli_3.2.0      
    ##  [5] tools_4.1.3     htmltools_0.5.2 yaml_2.3.5      stringi_1.7.6  
    ##  [9] rmarkdown_2.13  knitr_1.38      stringr_1.4.0   xfun_0.30      
    ## [13] digest_0.6.29   rlang_1.0.2     evaluate_0.15
