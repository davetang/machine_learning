# library(devtools)
# install_github('ramhiser/datamicroarray')

library(datamicroarray)
data('yeoh', package = "datamicroarray")

dim(yeoh$x)

table(yeoh$y)

my_dist <- dist(yeoh$x)
summary(my_dist)

my_hclust <- hclust(my_dist)

my_clus <- cutree(my_hclust, k = 6)

table(my_clus, yeoh$y)

cluster_one <- yeoh$y[my_clus == 1]

table(cluster_one)

my_clus_two <- cutree(my_hclust, h = 25)
table(my_clus_two, yeoh$y)

# install.packages('dendextend')
library(dendextend)
my_hclust_mod <- my_hclust
my_hclust_mod$labels <- as.vector(yeoh$y)
plot(color_branches(my_hclust_mod, h = 25, groupLabels = TRUE))
