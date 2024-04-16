# section 14.2

library(MASS)
data(Boston)
str(Boston)
names(Boston)
hist(Boston$medv, main="Boston Housing", xlab="Median Price")
medv.1 <- sqrt(Boston$medv)

library(rpart)
tree.1 <- rpart(medv.1 ~ . , data=Boston[,-14])
plot(tree.1, margin=0.1, main="Boston Housing")
text(tree.1, digits=2, all=TRUE, use.n=F, cex=0.8, col="blue")

plot(medv.1 ~ predict(tree.1), xlab="fitted", ylab="sqrt medv", 
    xlim=c(2,8), ylim=c(2,8), main="regression tree")
mse.1 <- mean((medv.1 - predict(tree.1))^2)
mse.0 <- mean((medv.1 - mean(medv.1))^2)
r.squared <- 1 - mse.1/mse.0
round(c(mse.0, mse.1), 3)
round(r.squared, 3)

n <- nrow(Boston)
indices <- sample(1:n, n, replace=T)
train <- Boston[indices,]
test <- Boston[-indices,]
tree.2 <- rpart(medv.1[indices] ~ . , data=train[,-14])
mse.2 <- mean((medv.1[-indices] - predict(tree.2, newdata=test))^2)
round(mse.2, 3)

# end
