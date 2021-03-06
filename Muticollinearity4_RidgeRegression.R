###################################################################
########################Ridge Regression R####################

data(BostonHousing)
str(BostonHousing)

summary(BostonHousing)
head(BostonHousing)

# Ridge regression uses lambda values to minimize error bw predicted 
# & actual Y. Lambda=0 represents OLS and very high values produce the mean of Y
# need to identify the optimum lambda

library(tidyverse)
library(broom)
library(glmnet)

y = BostonHousing$medv
x = BostonHousing %>% select(crim,zn,indus,chas,nox,rm,age,dis,rad,tax,ptratio,b,lstat) %>% data.matrix()
#  glmnet requires a vector input and matrix of predictors

lambdas = 10^seq(3, -2, by = -.1)#specify a range of lambda

fit <- glmnet(x, y, alpha = 0, lambda = lambdas) #alpha=0 in ridge
# ridge regression involves tuning a hyperparameter, lambda, 
#glmnet() runs the model many times for different values of lambda.

# which is the most optimal lambda value?

cv_fit <- cv.glmnet(x, y, alpha = 0, lambda = lambdas)
#cv.glmnet() uses cross-validation to work out 
#how well each model generalises

plot(cv_fit)
#lowest point in the curve indicates the optimal lambda

optlambda <- cv_fit$lambda.min
optlambda
#log value of lambda that best minimised the error

#predicting values and computing an R2 value for the data we trained on

y_predicted <- predict(fit, s = optlambda, newx = x)

# Sum of Squares Total and Error
sst <- sum(y^2)
sse <- sum((y_predicted - y)^2)

# R squared
rsq <- 1 - sse / sst
rsq

#The optimal model has accounted for 96% of the variance in the training data