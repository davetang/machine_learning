Introduction
------------

Install packages if missing and load.

    .libPaths('/packages')
    my_packages <- c('MASS', 'neuralnet')

    for (my_package in my_packages){
       if(!require(my_package, character.only = TRUE)){
          install.packages(my_package, '/packages')
          library(my_package, character.only = TRUE)
       }
    }

Compare neural network regression with linear regression
--------------------------------------------------------

Following the example from [this
tutorial](http://datascienceplus.com/fitting-neural-network-in-r/).

    set.seed(500)
    data <- Boston
    apply(data,2,function(x) sum(is.na(x)))

    ##    crim      zn   indus    chas     nox      rm     age     dis     rad     tax 
    ##       0       0       0       0       0       0       0       0       0       0 
    ## ptratio   black   lstat    medv 
    ##       0       0       0       0

    index <- sample(1:nrow(data), round(0.75*nrow(data)))
    train <- data[index,]
    test <- data[-index,]
    lm.fit <- glm(medv ~ ., data=train)
    summary(lm.fit)

    ## 
    ## Call:
    ## glm(formula = medv ~ ., data = train)
    ## 
    ## Deviance Residuals: 
    ##      Min        1Q    Median        3Q       Max  
    ## -15.2113   -2.5587   -0.6552    1.8275   29.7110  
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  31.111702   5.459811   5.698 2.49e-08 ***
    ## crim         -0.111372   0.033256  -3.349 0.000895 ***
    ## zn            0.042633   0.014307   2.980 0.003077 ** 
    ## indus         0.001483   0.067455   0.022 0.982473    
    ## chas          1.756844   0.981087   1.791 0.074166 .  
    ## nox         -18.184847   4.471572  -4.067 5.84e-05 ***
    ## rm            4.760341   0.480472   9.908  < 2e-16 ***
    ## age          -0.013439   0.014101  -0.953 0.341190    
    ## dis          -1.553748   0.218929  -7.097 6.65e-12 ***
    ## rad           0.288181   0.072017   4.002 7.62e-05 ***
    ## tax          -0.013739   0.004060  -3.384 0.000791 ***
    ## ptratio      -0.947549   0.140120  -6.762 5.38e-11 ***
    ## black         0.009502   0.002901   3.276 0.001154 ** 
    ## lstat        -0.388902   0.059733  -6.511 2.47e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for gaussian family taken to be 20.23806)
    ## 
    ##     Null deviance: 32463.5  on 379  degrees of freedom
    ## Residual deviance:  7407.1  on 366  degrees of freedom
    ## AIC: 2237
    ## 
    ## Number of Fisher Scoring iterations: 2

    pr.lm <- predict(lm.fit, test)
    MSE.lm <- sum((pr.lm - test$medv)^2)/nrow(test)

Feature scaling
---------------

[Feature scaling](https://en.wikipedia.org/wiki/Feature_scaling) using:

$$ x' = \\frac{x - min(x)}{max(x) - min(x)} $$

    x <- 1:20
    x_a <- (x - min(x)) / (max(x) - min(x))
    x_b <- as.vector(scale(x, center = min(x), scale = max(x) - min(x)))
    x_a

    ##  [1] 0.00000000 0.05263158 0.10526316 0.15789474 0.21052632 0.26315789
    ##  [7] 0.31578947 0.36842105 0.42105263 0.47368421 0.52631579 0.57894737
    ## [13] 0.63157895 0.68421053 0.73684211 0.78947368 0.84210526 0.89473684
    ## [19] 0.94736842 1.00000000

    identical(x_a, x_b)

    ## [1] TRUE

Carrying out the normalisation.

    maxs <- apply(data, 2, max)
    mins <- apply(data, 2, min)

    scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))

    train_ <- scaled[index,]
    test_ <- scaled[-index,]

Training
--------

Manually create formula as `f` since neuralnet() doesn’t recognise
`medv ~ .`.

    n <- names(train_)
    f <- as.formula(paste("medv ~", paste(n[!n %in% "medv"], collapse = " + ")))

    nn <- neuralnet(f, data = train_, hidden=c(5,3), linear.output = TRUE)
    plot(nn)

Prediction
----------

We need to unscale the predictions and test; remember the formula:

$$ x' = \\frac{x - min(x)}{max(x) - min(x)} $$

    x <- 1:20
    x_a <- (x - min(x)) / (max(x) - min(x))
    x_orig <- as.integer(x_a * (max(x) - min(x)) + (min(x)))
    identical(x, x_orig)

    ## [1] TRUE

Compare RMS of neural network regression with linear regression.

    pr.nn <- compute(nn, test_[,1:13])
    pr.nn_ <- pr.nn$net.result * (max(data$medv) - min(data$medv)) + min(data$medv)
    test.r <- (test_$medv) * (max(data$medv) - min(data$medv)) + min(data$medv)

    MSE.nn <- sum((test.r - pr.nn_)^2)/nrow(test_)
    print(paste(MSE.lm,MSE.nn))

    ## [1] "31.2630222372615 16.4595537665717"

Further reading
---------------

The neuralnet [reference
manual](https://cran.r-project.org/web/packages/neuralnet/neuralnet.pdf).

Session info
------------

Time built.

    ## [1] "2022-04-09 02:52:35 UTC"

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
    ##  [1] neuralnet_1.44.2 MASS_7.3-55      forcats_0.5.1    stringr_1.4.0   
    ##  [5] dplyr_1.0.8      purrr_0.3.4      readr_2.1.2      tidyr_1.2.0     
    ##  [9] tibble_3.1.6     ggplot2_3.3.5    tidyverse_1.3.1 
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.2 xfun_0.30        haven_2.4.3      colorspace_2.0-3
    ##  [5] vctrs_0.4.0      generics_0.1.2   htmltools_0.5.2  yaml_2.3.5      
    ##  [9] utf8_1.2.2       rlang_1.0.2      pillar_1.7.0     glue_1.6.2      
    ## [13] withr_2.5.0      DBI_1.1.2        dbplyr_2.1.1     modelr_0.1.8    
    ## [17] readxl_1.4.0     lifecycle_1.0.1  munsell_0.5.0    gtable_0.3.0    
    ## [21] cellranger_1.1.0 rvest_1.0.2      evaluate_0.15    knitr_1.38      
    ## [25] tzdb_0.3.0       fastmap_1.1.0    fansi_1.0.3      broom_0.7.12    
    ## [29] scales_1.1.1     backports_1.4.1  jsonlite_1.8.0   fs_1.5.2        
    ## [33] hms_1.1.1        digest_0.6.29    stringi_1.7.6    grid_4.1.3      
    ## [37] cli_3.2.0        tools_4.1.3      magrittr_2.0.3   crayon_1.5.1    
    ## [41] pkgconfig_2.0.3  ellipsis_0.3.2   xml2_1.3.3       reprex_2.0.1    
    ## [45] lubridate_1.8.0  rstudioapi_0.13  assertthat_0.2.1 rmarkdown_2.13  
    ## [49] httr_1.4.2       R6_2.5.1         compiler_4.1.3
