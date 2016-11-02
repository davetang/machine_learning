Support Vector Machine
======================

A support vector machine (SVM) is a supervised machine learning algorithm that can be used for classification and regression. The essence of SVM classification is broken down into four main concepts:

1. The separating hyperplane (a plane that can separate cases into their respective classes)
2. The maximum-margin hyperplane or maximum-margin linear discriminants (the hyperplane that has maximal distance from the different classes)

![Example of the maximum-margin hyperplane](image/SVM_Example_of_Hyperplanes.png)

3. The soft margin (allowing cases from another class to fall into the opposite class)
4. The kernel function (adding an additional dimension)

SVMs rely on preprocessing the data to represent patterns in a high dimension using a kernel function, typically much higher than the original feature space.

## The kernel function

In essence, the kernel function is a mathematical trick that allows the SVM to perform a "two-dimensional" classification of a set of originally one-dimensional data. In general, a kernel function projects data from a low-dimensional space to a space of higher dimension. It is possible to prove that, for any given data set with consistent labels (where consistent simply means that the data set does not contain two identical objects with opposite labels) there exists a kernel function that will allow the data to be linearly separated ([Noble, Nature Biotechnology 2006](https://www.ncbi.nlm.nih.gov/pubmed/17160063)).

Using a hyperplane from an SVM that uses a very high-dimensional kernel function will result in overfitting. An optimal kernel function can be selected from a fixed set of kernels in a statistically rigorous fashion by using cross-validation. Kernels also allow us to combine different data sets.

## Example

Using the [Breast Cancer Wisconsin (Diagnostic) Data Set](http://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)); see example.Rmd and example.pdf.

```
7. Attribute Information: (class attribute has been moved to last column)

   #  Attribute                     Domain
   -- -----------------------------------------
   1. Sample code number            id number
   2. Clump Thickness               1 - 10
   3. Uniformity of Cell Size       1 - 10
   4. Uniformity of Cell Shape      1 - 10
   5. Marginal Adhesion             1 - 10
   6. Single Epithelial Cell Size   1 - 10
   7. Bare Nuclei                   1 - 10
   8. Bland Chromatin               1 - 10
   9. Normal Nucleoli               1 - 10
  10. Mitoses                       1 - 10
  11. Class:                        (2 for benign, 4 for malignant)
```

## Further reading

* [Data Mining Algorithms In R/Classification/SVM](https://en.wikibooks.org/wiki/Data_Mining_Algorithms_In_R/Classification/SVM)

