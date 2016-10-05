# install packages if necessary
install.packages("tree")
install.packages('rpart')
install.packages('rpart.plot')

library(tree)

tree1 <- tree(Species ~ Sepal.Width + Petal.Width, data = iris)
summary(tree1)
plot(tree1)
text(tree1)

plot(iris$Petal.Width,iris$Sepal.Width,pch=19,col=as.numeric(iris$Species))
partition.tree(tree1,label="Species",add=TRUE)
legend(1.75,4.5,legend=unique(iris$Species),col=unique(as.numeric(iris$Species)),pch=19)

tree2 <- tree(Species ~ Sepal.Width + Sepal.Length + Petal.Length + Petal.Width, data = iris)
summary(tree2)
plot(tree2)
text(tree2)

library(rpart)

rpart <- rpart(Species ~ ., data=iris, method="class")
summary(rpart)

library(rpart.plot)

rpart.plot(rpart)

setwd('~/github/machine_learning/tree/')
# file from https://www.kaggle.com/c/titanic/data?train.csv

# Survived        Survival (0 = No; 1 = Yes)
# Pclass          Passenger Class (1 = 1st; 2 = 2nd; 3 = 3rd)
# Name            Name
# Sex             Sex
# Age             Age
# SibSp           Number of Siblings/Spouses Aboard
# Parch           Number of Parents/Children Aboard
# Ticket          Ticket Number
# Fare            Passenger Fare
# Cabin           Cabin
# Embarked        Port of Embarkation (C = Cherbourg; Q = Queenstown; S = Southampton)

titanic <- read.csv('../data/titanic.csv.gz')
str(titanic)

titanic$Pclass <- factor(titanic$Pclass)
boxplot(Fare ~ Pclass, data = titanic)

t <-  rpart(Survived ~ Sex + Fare + Age, data=titanic, method="class")
rpart.plot(t)
