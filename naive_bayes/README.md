Naive Bayes
===========

Naive Bayes is based on [Bayes' theorem](https://en.wikipedia.org/wiki/Bayes%27_theorem) 

![Bayes' theorem](http://latex.codecogs.com/gif.latex?P(A|B)=\frac{P(B|A)P(A)}{P(B)})

where A and B are events and P(B) is not equal to 0.

* The formula can be interpreted as the chance of a true positive result divided by the chance of any positive result (true positive + false positive)
* P(A|B) is a conditional probability: the likelihood of event A occurring given that B is true; this is known as the posterior probability
* P(B|A) is also a conditional probability: the likelihood of event B occurring given that A is true
* P(A) and P(B) are the probabilities of observing A and B independently of each other; this is known as the marginal probability and are the prior probabilities

Classifiers based on Bayesian methods utilise training data to calculate an observed probability of each class based on feature values. An example is using Bayes' theorem to classify emails; we can use known ham and spam emails to tally up the occurrence of words to obtain prior and conditional probabilities, and use these probabilities to classify new emails. Bayesian classifiers utilise all available evidence to come up with a classification thus they are best applied to problems where the information from numerous attributes should be considered simultaneously

* The "naive" part of the method refers to a assumption that all features in a dataset are equally important and independent, which is usually not true; despite this, the method performs quite well in certain applications like spam classification

## Example

See `naive_bayes.html` for more elaboration.

```{r}
# load library
library(e1071)

# use the iris dataset
data(iris)

# set seed for reproducibility
set.seed(1984)

# create index for creating a training and testing set
my_index <- sample(x = 1:nrow(iris), size = .8*(nrow(iris)))

# training data
my_train <- iris[my_index, -5]
my_train_label <- iris[my_index, 5]

# testing data
my_test <- iris[!1:nrow(iris) %in% my_index, -5]
my_test_label <- iris[!1:nrow(iris) %in% my_index, 5]

# train
m <- naiveBayes(my_train, my_train_label)

# classify test data
table(predict(m, my_test), my_test_label)
##              my_test_label
##              setosa versicolor virginica
##   setosa         11          0         0
##   versicolor      0         10         0
##   virginica       0          1         8
```

## Further reading

* [An Intuitive (and Short) Explanation of Bayes' Theorem](https://betterexplained.com/articles/an-intuitive-and-short-explanation-of-bayes-theorem/)
* [Naive Bayes for Machine Learning](https://machinelearningmastery.com/naive-bayes-for-machine-learning/)

