Naive Bayes
================

## Introduction

Naive Bayes is a machine learning approach based on [Bayes’
theorem](https://en.wikipedia.org/wiki/Bayes%27_theorem), which
describes the probability of an event, based on prior knowledge of
conditions that might be related to the event. For example, if the risk
of developing health problems is known to increase with age, Bayes’
theorem allows the risk to an individual of a known age to be assessed
more accurately (by conditioning it on their age) than simply assuming
that the individual is typical of the population as a whole. The theorem
is stated mathematically as:

  
![ P(A|B)=\\frac{P(B|A)P(A)}{P(B)}
](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%20P%28A%7CB%29%3D%5Cfrac%7BP%28B%7CA%29P%28A%29%7D%7BP%28B%29%7D%20
" P(A|B)=\\frac{P(B|A)P(A)}{P(B)} ")  

where A and B are events and P(B) is not equal to 0.

  - P(A|B) is a conditional probability: the likelihood of event A
    occurring given that B is true; this is the posterior probability
  - P(B|A) is also a conditional probability: the likelihood of event B
    occurring given that A is true
  - P(A) and P(B) are the probabilities of observing A and B
    independently of each other; they are known as marginal
    probabilities and are the prior probabilities

The formula can be interpreted as the chance of a true positive result,
divided by the chance of any positive result (true positive + false
positive).

A typical example used for illustrating Bayes theorem is on calculating
the probability that a [drug
test](https://en.wikipedia.org/wiki/Bayes%27_theorem#Drug_testing) comes
up positive with a drug user. Suppose a particular drug test is correct
90% of the times at detecting drug use, i.e. 90% positive when a user
has been using drugs, and is correct 80% of the times at detecting
non-users. We also know that 5% of the population use this drug. Given
what we know, what is the probability that a person is a drug user when
the test turns up positive? Isn’t this just 90% or 0.9? Not quite, since
we have prior knowledge that only 5% of people are drug users and that
the test can turn up positive even with non-users. If we apply Bayes’
theorem and let
![P(User|Positive)](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;P%28User%7CPositive%29
"P(User|Positive)") mean the probability that someone is a drug user
given that they tested positive, then:

  
![ P(User | Positive) = \\frac{P (Positive | User) P(User)}{P(Positive)}
](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%20P%28User%20%7C%20Positive%29%20%3D%20%5Cfrac%7BP%20%28Positive%20%7C%20User%29%20P%28User%29%7D%7BP%28Positive%29%7D%20
" P(User | Positive) = \\frac{P (Positive | User) P(User)}{P(Positive)} ")  

The nominator is the
![0.045](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;0.045
"0.045"), since

  - ![P(Positive|User)
    = 0.90](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;P%28Positive%7CUser%29%20%3D%200.90
    "P(Positive|User) = 0.90")
  - ![P(User)
    = 0.05](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;P%28User%29%20%3D%200.05
    "P(User) = 0.05")

For working out
![P(Positive)](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;P%28Positive%29
"P(Positive)"), there are two scenarios that a test turns up positive:

  - ![P(Positive|User) = 0.90 \\times 0.05
    = 0.045](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;P%28Positive%7CUser%29%20%3D%200.90%20%5Ctimes%200.05%20%3D%200.045
    "P(Positive|User) = 0.90 \\times 0.05 = 0.045")
  - ![P(Positive|Non-user) = 0.20 \\times 0.95
    = 0.19](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;P%28Positive%7CNon-user%29%20%3D%200.20%20%5Ctimes%200.95%20%3D%200.19
    "P(Positive|Non-user) = 0.20 \\times 0.95 = 0.19")

Therefore, the probability that a person is a drug-user given a positive
test result is:

  
![ \\frac{0.045}{0.045 + 0.19} = .1914 \\approx 19%
](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%20%5Cfrac%7B0.045%7D%7B0.045%20%2B%200.19%7D%20%3D%20.1914%20%5Capprox%2019%25%20
" \\frac{0.045}{0.045 + 0.19} = .1914 \\approx 19% ")  

Classifiers based on Bayesian methods utilise training data to calculate
an observed probability of each class based on feature values. An
example is using Bayes’ theorem to classify emails; we can use known ham
and spam emails to tally up the occurrence of words to obtain prior and
conditional probabilities, and use these probabilities to classify new
emails. Bayesian classifiers utilise all available evidence to come up
with a classification thus they are best applied to problems where the
information from numerous attributes should be considered simultaneously

  - The “naive” part of the method refers to a assumption that all
    features in a dataset are equally important and independent, which
    is usually not true; despite this, the method performs quite well in
    certain applications like spam classification

Install packages if missing and load.

``` r
.libPaths('/packages')
my_packages <- 'e1071'

for (my_package in my_packages){
   if(!require(my_package, character.only = TRUE)){
      install.packages(my_package, '/packages')
      library(my_package, character.only = TRUE)
   }
}
```

## Example

Classifiers based on Bayesian methods utilise training data to calculate
an observed probability of each class based on feature values. The
classifier uses observed probabilities from unlabelled data to predict
the most likely class.

Use the `naiveBayes()` function from the `e1071` package to perform
[Gaussian naive
Bayes](https://en.wikipedia.org/wiki/Naive_Bayes_classifier#Gaussian_naive_Bayes).
Divide the dataset in 80% training and 20% testing.

``` r
set.seed(1984)
my_index <- sample(x = 1:nrow(iris), size = .8*(nrow(iris)))

my_train <- iris[my_index, -5]
my_train_label <- iris[my_index, 5]

my_test <- iris[!1:nrow(iris) %in% my_index, -5]
my_test_label <- iris[!1:nrow(iris) %in% my_index, 5]

m <- naiveBayes(my_train, my_train_label)

m
```

    ## 
    ## Naive Bayes Classifier for Discrete Predictors
    ## 
    ## Call:
    ## naiveBayes.default(x = my_train, y = my_train_label)
    ## 
    ## A-priori probabilities:
    ## my_train_label
    ##     setosa versicolor  virginica 
    ##  0.3583333  0.3333333  0.3083333 
    ## 
    ## Conditional probabilities:
    ##               Sepal.Length
    ## my_train_label     [,1]      [,2]
    ##     setosa     4.972093 0.3340413
    ##     versicolor 5.957500 0.4744160
    ##     virginica  6.651351 0.5465150
    ## 
    ##               Sepal.Width
    ## my_train_label     [,1]      [,2]
    ##     setosa     3.406977 0.3832166
    ##     versicolor 2.777500 0.2805558
    ##     virginica  2.989189 0.3186637
    ## 
    ##               Petal.Length
    ## my_train_label     [,1]      [,2]
    ##     setosa     1.460465 0.1774684
    ##     versicolor 4.282500 0.4595915
    ##     virginica  5.586486 0.4882862
    ## 
    ##               Petal.Width
    ## my_train_label      [,1]      [,2]
    ##     setosa     0.2418605 0.1096153
    ##     versicolor 1.3300000 0.1842518
    ##     virginica  2.0621622 0.2742174

The values are the mean and variance for each feature stratified by
class.

``` r
iris[my_index,] %>%
  group_by(Species) %>%
  summarise(mean = mean(Petal.Width), var = var(Petal.Width))
```

    ## # A tibble: 3 × 3
    ##   Species     mean    var
    ##   <fct>      <dbl>  <dbl>
    ## 1 setosa     0.242 0.0120
    ## 2 versicolor 1.33  0.0339
    ## 3 virginica  2.06  0.0752

Classify the test set and tabulate based on the real labels; only one
misclassification of a virginica as a versicolor.

``` r
table(predict(m, my_test), my_test_label)
```

    ##             my_test_label
    ##              setosa versicolor virginica
    ##   setosa          7          0         0
    ##   versicolor      0          9         2
    ##   virginica       0          1        11

## Further reading

  - [An Intuitive (and Short) Explanation of Bayes’
    Theorem](https://betterexplained.com/articles/an-intuitive-and-short-explanation-of-bayes-theorem/)
  - [Naive Bayes for Machine
    Learning](https://machinelearningmastery.com/naive-bayes-for-machine-learning/)

## Session info

Time built.

    ## [1] "2022-07-12 04:48:52 UTC"

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
    ##  [1] tidyselect_1.1.2 xfun_0.30        haven_2.5.0      colorspace_2.0-3
    ##  [5] vctrs_0.4.1      generics_0.1.2   htmltools_0.5.2  yaml_2.3.5      
    ##  [9] utf8_1.2.2       rlang_1.0.2      pillar_1.7.0     glue_1.6.2      
    ## [13] withr_2.5.0      DBI_1.1.2        dbplyr_2.1.1     modelr_0.1.8    
    ## [17] readxl_1.4.0     lifecycle_1.0.1  munsell_0.5.0    gtable_0.3.0    
    ## [21] cellranger_1.1.0 rvest_1.0.2      evaluate_0.15    knitr_1.38      
    ## [25] tzdb_0.3.0       fastmap_1.1.0    class_7.3-20     fansi_1.0.3     
    ## [29] broom_0.8.0      scales_1.2.0     backports_1.4.1  jsonlite_1.8.0  
    ## [33] fs_1.5.2         hms_1.1.1        digest_0.6.29    stringi_1.7.6   
    ## [37] grid_4.1.3       cli_3.2.0        tools_4.1.3      magrittr_2.0.3  
    ## [41] proxy_0.4-26     crayon_1.5.1     pkgconfig_2.0.3  ellipsis_0.3.2  
    ## [45] xml2_1.3.3       reprex_2.0.1     lubridate_1.8.0  rstudioapi_0.13 
    ## [49] assertthat_0.2.1 rmarkdown_2.13   httr_1.4.2       R6_2.5.1        
    ## [53] compiler_4.1.3
