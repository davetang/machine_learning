Table of Contents
=================

* [A brief history of machine learning](#a-brief-history-of-machine-learning)
* [Main challenges](#main-challenges)
* [Why predictions fail?](#why-predictions-fail)
* [Machine learning project checklist](#machine-learning-project-checklist)
* [Resources](#resources)
   * [Presentations](#presentations)
   * [Tutorials](#tutorials)
   * [Online content](#online-content)
   * [Papers](#papers)
   * [Books](#books)
   * [Datasets](#datasets)
   * [Others](#others)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# A brief history of machine learning

_Machine Learning is the study of computer algorithms that improve automatically through experience. --Tom Mitchell_

Adapted from the section 1.2 of the book "Deep Learning with R".

* Probabilistic modelling was one of the earliest forms of machine learning,
where the principles of statistics were applied to data analysis.
* The Naive Bayes algorithm is one of the best known methods for carrying out
probabilistic modelling.
* Logistic regression is an algorithm with roots that date back to the early 19th century.
* The core ideas of neural networks were investigated back in the 1950s.
* In the 1970s, the backpropagation algorithm was originally introduced.
* Kernel methods, especially Support Vector Machines (SVMs), become popular in the 90s.
* Decision trees [date back in the 1960s](http://washstat.org/presentations/20150604/loh_slides.pdf).
* The first algorithm for random decision trees was created in 1995 and an
extension of the algorithm, called Random Forests, was created in 2001.
* Gradient boosting is a machine-learning technique based on ensembling weak
prediction models, generally decision trees, which originated in 1997.
* In 2012, the SuperVision team led by Alex Krizhevsky and advised by Geoffrey
Hinton was able to achieve a top-five accuracy of [83.6% on the ImageNet
challenge](http://www.image-net.org/challenges/LSVRC/2012/results.html).

# Main challenges

* Most machine learning algorithms require a lot of data to work properly; if
your sample is too small, sampling noise will have a larger effect.
* In addition, training data needs to representative, i.e. equally sampling
from different labels or range of values, for a model to generalise.
Non-representative data can result from a flawed sampling method (but sometimes
it is just difficult to collect the necessary data).
* Poor quality data will make it more difficult to detect underlying trends and
a lot of time is required to "clean up" the data, e.g. dealing with missing
values and removing or fixing outliers.
* Models are only capable of learning if there are enough relevant features. A
critical part of machine learning is feature engineering, which typically
involves ***feature selection*** (selecting the most useful features) and ***feature
extraction*** (combining existing features to produce more useful ones).
* Avoiding overfitting, which is when the model performs well on the training
data but does not generalise and this usually occurs when the model is too
complex. Constraining a model to make it simpler and reducing the risk of
overfitting is called ***regularisation***. The amount of regularisation to
apply during learning can be controlled by a ***hyperparameter***, which is a
parameter that is not part of the model.
* Avoiding underfitting, which is when the model is too simple to learn the
underlying structure of the data.

# Why predictions fail?

Reasons machine learning models fail to make correct predictions despite having
enough data:

1. Inadequate pre-processing of data
2. Inadequate model validation (the procedure where a trained model is assessed
   with testing data)
3. Inappropriate model was used
4. Unjustified extrapolation (making predictions on new data that is
   characteristically different from the training data)
5. Over-fitting the model on existing data

# Machine learning project checklist

A useful checklist for machine learning projects from [Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow 3rd edition](https://www.ebooks.com/en-us/book/210681725/hands-on-machine-learning-with-scikit-learn-keras-and-tensorflow/aur-lien-g-ron/).

1. Frame the problem and look at the big picture.
2. Get the data.
3. Explore the data to gain insights.
4. Prepare the data to better expose the underlying data patterns to machine
   learning algorithms.
5. Explore many different models and shortlist the best ones.
6. Fine-tune your models and combine them into a great solution.
7. Present your solution.
8. Launch, monitor, and maintain your system.

Adapt this checklist to your project needs!

# Resources

A list of useful resources for learning about machine learning with an emphasis
on biological applications.

## Presentations

* [Some Things Every Biologist Should Know About Machine Learning](http://www.bioconductor.org/help/course-materials/2003/Milan/Lectures/MachineLearning.pdf) by Robert Gentleman

## Tutorials

* [How to Perform a Logistic Regression in R](http://datascienceplus.com/perform-logistic-regression-in-r/)
* [A gentle introduction to decision trees using R](https://eight2late.wordpress.com/2016/02/16/a-gentle-introduction-to-decision-trees-using-r/)
* [A gentle introduction to random forests using R](https://eight2late.wordpress.com/2016/09/20/a-gentle-introduction-to-random-forests-using-r/)
* [Random Forest Regression and Classification in R and Python](http://blog.yhat.com/posts/comparing-random-forests-in-python-and-r.html)
* [Fitting a Neural Network in R using the neuralnet package](http://datascienceplus.com/fitting-neural-network-in-r/)

## Online content

* [A Tour of The Top 10 Algorithms for Machine Learning Newbies](https://towardsdatascience.com/a-tour-of-the-top-10-algorithms-for-machine-learning-newbies-dde4edffae11)
* [Comparing supervised learning algorithms](http://www.dataschool.io/comparing-supervised-learning-algorithms/)
* [How to get better at data science](http://www.dataschool.io/how-to-get-better-at-data-science/)

## Papers

* [What is Bayesian statistics](http://dx.doi.org/10.1038/nbt0904-1177) by Sean Eddy
* [What is a support vector machine?](http://dx.doi.org/10.1038/nbt1206-1565) by William Noble
* [What is a hidden Markov model?](http://dx.doi.org/10.1038/nbt1004-1315) by Sean Eddy
* [What are artificial neural networks](http://dx.doi.org/10.1038/nbt1386) by Anders Krogh
* [Deep learning for computational biology](http://dx.doi.org/10.15252/msb.20156651) by Angermueller et al.
* [Machine learning applications in genetics and genomics](http://dx.doi.org/10.1038/nrg3920) by Maxwell Libbrecht and William Noble
* [Conditional variable importance for random forests](http://www.ncbi.nlm.nih.gov/pubmed/18620558)

## Books

* [The Elements of Statistical Learning](https://web.stanford.edu/~hastie/ElemStatLearn/) by Trevor Hastie, Robert Tibshirani, and Jerome Friedman
* [An Introduction to Statistical Learning](http://www-bcf.usc.edu/~gareth/ISL/) by Gareth James, Daniela Witten, Trevor Hastie, and Robert Tibshirani
* [Introduction to Machine Learning](https://mitpress.mit.edu/books/introduction-machine-learning) by Ethem Alpaydin
* [Deep Learning with R](https://www.manning.com/books/deep-learning-with-r) by François Chollet with J. J. Allaire

## Datasets

* [Medical Data for Machine Learning](https://github.com/beamandrew/medical-data) by Andrew Beam
* [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets.html)
* [Kaggle Datasets](https://www.kaggle.com/datasets)
* [A collection of microarray data](https://github.com/ramhiser/datamicroarray) by John Ramey

## Others

* Tom Mitchell's [home page](http://www.cs.cmu.edu/~tom/)
* [My notes on Random Forests](https://github.com/davetang/learning_random_forest)
* [No Free Lunch Theorems](http://www.no-free-lunch.org/)
