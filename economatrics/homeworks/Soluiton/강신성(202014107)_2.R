
#--------------------homework 2------------------------------------------------

# We learned the following R code in class. Answer the following questions using this code. 

#------------example: Scatter Plot---------------------------------
n<-1000
x<-4+rnorm(n,mean=1,sd=5)
y<-1+2*x+rnorm(n,mean=0,sd=4)

dev.new()
plot(x,y, pch=16, col="blue", 
     main=expression(paste("Sampling under ", beta[0], 
                           "=1", " ", "and", " ", beta[1], "=2")))
text(10, 2, "scatter plot", cex=1.5)
abline(a=1,b=2, col="red", lwd=3)


#------------------------------------------------------------------
# question 1: Compute the mean values of x and y using "for loop"!
#             Do not use built-in functions!!! 

## 평균을 내주는 함수 : mean_values() 정의

mean_values <- function(values) {
  output <- 0
  
  for (i in values) {
    output <- output + i
  }

  output / length(values)   ## 평균을 구하기 위해 자료의 수(length)로 나누어준다.
}

mean_values(x)   ## x의 평균을 계산 | output : 5.088852
mean_values(y)   ## y의 평균을 계산 | output : 11.21303


#------------------------------------------------------------------
# question 2: Compute the covariance between x and y using "for loop"!
#             Do not use built-in functions!!! 

## 공분산을 내주는 함수 : cov_values() 정의

cov_values <- function(data_1, data_2) {
  x_diff <- data_1 - mean_values(data_1)   ## 위에서 정의했던 함수 "mean_values()" 사용
  y_diff <- data_2 - mean_values(data_2)

  xy_product <- x_diff * y_diff
  
  product_sum <- 0
  
  for (i in xy_product) {
    product_sum <- product_sum + i
  }
  
  cov = product_sum / (length(xy_product) - 1)  ## 표본 공분산
  
  cov
}

cov_values(x,y)   ## output : 48.18198


#------------------------------------------------------------------
# question 3: Compute the variance x using "for loop"!
#             Do not use built-in functions!!! 

## 분산을 내어주는 함수 : var_values() 정의

var_values <- function(values) {
  x_diff_sq <- (values - mean_values(values))^2   ## 위에서 정의했던 함수 "mean_values()" 사용하여 차의 제곱 행렬 생성
  
  sum_x_sq <- 0
  
  for (i in x_diff_sq) {
    sum_x_sq <- sum_x_sq + i
  }
  
  var_x <- sum_x_sq / (length(values) - 1)  ## 표본 분산
  
  var_x
}

var_values(x)     ## output : 23.94029


#--------------------------------------------------------------------------
# question 4: Compute the parameter beta[1] (slope of the regression line)!

## 최소제곱법으로 beta[1]의 값을 추정해보자

beta_1_hat <- cov_values(x, y) / var_values(x)  ## 위에서 정의한 함수를 사용 : x와 y의 공분산 / x의 분산

beta_1_hat  ## output : 2.01259