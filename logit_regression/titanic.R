setwd("~/github/machine_learning/logit_regression/")

library(dplyr)

data <- read.csv("../data/titanic.csv.gz", na.strings = '')
sapply(data, function(x) sum(is.na(x)))
sapply(data, function(x) length(unique(na.omit(x))))

# install.packages('Amelia')
library(Amelia)
missmap(data)

data_subset <- select(data, -PassengerId, -Ticket, -Cabin, -Name)
data_subset <- filter(data_subset, !is.na(Embarked))

# data_subset$Age[is.na(data_subset$Age)] <- mean(data_subset$Age, na.rm=TRUE)

train <- data_subset[1:800,]
test  <- data_subset[801:nrow(data_subset),]

model <- glm(Survived ~.,
             family=binomial(link='logit'),
             data=train)

fitted <- predict(model,
                  newdata=test[,-1],
                  type='response')

library(ROCR)
pr <- prediction(fitted, test$Survived)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
auc <- performance(pr, measure = "auc")
plot(prf)
legend(x = 0.75, y = 0.05, legend = paste("AUC = ", auc@y.values), bty = 'n')

