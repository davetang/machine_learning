k-Nearest Neighbours
====================

In pattern recognition, the [k-Nearest Neighbours algorithm](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm) (k-NN) is a non-parametric method used for classification and regression. In both cases, the input consists of the k closest training examples in the feature space.

Example implementation in R below that uses the `women` data set. The algorithm first calculates the absolute distance of an input (or an input set) to a known set of data points for the same variable. By sorting the distances, the nearest features are ranked first. Finally, the independent variables for the k-nearest features are used to calculate the mean. In the example below, we want to predict the weight of a female who is 60 inches tall. The `women` data set in R contains height and weight data for 15 American women aged between 30–39.

~~~~{.r}
# dv:       dependent variable
# dv_train: dependent variable of training set
# iv_train: indendent variable of training set
# k:        number of nearest neighbours

knn <- function(dv, dv_train, iv_train, k){
  m <- length(dv)
  predict_knn <- rep(0, m)
  for (i in 1:m) {
    dist <- abs(dv[i] - dv_train)
    sort_index <- order(dist)
    predict_knn[i] <- mean(iv_train[sort_index[1:k]])
  }
  return(predict_knn)
}

knn(60, women$height, women$weight, 4) # 118.75
knn(60, women$height, women$weight, 5) # 120.2
~~~~

