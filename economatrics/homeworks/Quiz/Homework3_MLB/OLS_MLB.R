
rm(list = ls(all=T)) # This code clears all. 
load("C:\\Users\\hollyriver\\Documents\\Github\\R\\economatrics\\homeworks\\Quiz\\Homework3_MLB\\mlb1.RData") #load data

ls(data) #list of variables
head(data)

head(data$lsalary)
# dependent variable
lsalary <- data$lsalary #log(salary) variable, responsible variable

#explanatory variables
years <- data$years     #years of experience  /  나이
gamesyr <- data$gamesyr #average games each year / 연 평균 경기 수
bavg <- data$bavg       #batting average  /  타율
hrunsyr <-data$hrunsyr  #home runs
rbisyr <-data$rbisyr    #run batted in  /  플레이 년도 수

#plot--------------------------------------------------------------
dev.new()
plot(rbisyr,lsalary,  pch=16, col="blue", cex=1.5, )


#Scatter Plot------------------------------------------------------
mlb.data<-data.frame(years, gamesyr, bavg, hrunsyr, rbisyr,lsalary)  ## bind on dataframe
dev.new()
pairs(mlb.data, col="blue", pch=16, cex=0.5, cex.axis=1.25)

#-------------Correlation plot-------------------------------------
install.packages("corrplot")
library(corrplot)
cor.mat<-cor(mlb.data)
cor.mat  ## correlation or matrix
dev.new()
corrplot.mixed(cor.mat, lower="number", upper="circle")  ## sns.heatmap()이랑 비슷한듯

model <- lm(lsalary ~ years + gamesyr + bavg + hrunsyr + rbisyr, data = mlb.data)
summary(model)
round(model$coefficients, 5)

#-------------Homework------------------------------------------
# Do not use the lm() function. Answer the following questions

#1. Compute the betas (beta0,...,beta5).

X <- cbind(1, years, gamesyr, bavg, hrunsyr, rbisyr)  ## explanatory variables matrix
Y <- lsalary  ## responsible variable matrix

betas_hat <- solve(t(X)%*%X)%*%t(X)%*%Y
round(betas_hat, 5)

# > round(betas_hat, 5)
#             [,1]
#         11.19242
# years    0.06886
# gamesyr  0.01255
# bavg     0.00098
# hrunsyr  0.01443
# rbisyr   0.01077


#2. Compute the variance of the betas.

n <- length(lsalary)
k <- 5

Y_hat <- X%*%betas_hat
sigma2_hat <- as.numeric(t(Y - Y_hat)%*%(Y - Y_hat)/(n-k-1))

betas_cov <- sigma2_hat*solve(t(X)%*%X)

betas_var <- diag(betas_cov)
round(betas_var, 5)

# > round(betas_var, 5)
#           years gamesyr    bavg hrunsyr  rbisyr 
# 0.08342 0.00015 0.00001 0.00000 0.00026 0.00005 


#3. Compute the t-values for the betas.

se_betas <- sqrt(betas_var); se_betas
t_values <- betas_hat/se_betas
t_values

# > t_values
#               [,1]
#         38.7518435
# years    5.6842951
# gamesyr  4.7424413
# bavg     0.8868111
# hrunsyr  0.8986418
# rbisyr   1.5004588


#4. Compute the p-values for the betas. 

for (q in t_values) {
  print(pt(q = q, df = n-k-1, lower.tail = FALSE))
}

# [1] 2.09365e-128  ## intercept
# [1] 1.39379e-08   ## years
# [1] 1.544307e-06  ## gamesyr
# [1] 0.1878974     ## bavg
# [1] 0.1847333     ## hrunsyr
# [1] 0.06720246    ## rbisyr


#---------------------------------------------------------------

#-------------Homework------------------------------------------
# Do not use the lm() function. Answer the following questions

#1. Compute the betas (beta0,...,beta5).

X <- cbind(1, years, gamesyr, bavg, hrunsyr, rbisyr)  ## explanatory variables matrix
Y <- lsalary  ## responsible variable matrix

betas_hat <- solve(t(X)%*%X)%*%t(X)%*%Y
round(betas_hat, 5)

# output
# > round(betas_hat, 5)
#             [,1]
#         11.19242
# years    0.06886
# gamesyr  0.01255
# bavg     0.00098
# hrunsyr  0.01443
# rbisyr   0.01077


#2. Compute the variance of the betas.

n <- length(lsalary)
k <- 5

Y_hat <- X%*%betas_hat
sigma2_hat <- as.numeric(t(Y - Y_hat)%*%(Y - Y_hat)/(n-k-1))
betas_cov <- sigma2_hat*solve(t(X)%*%X)
betas_var <- diag(betas_cov)
round(betas_var, 5)

# output
# > round(betas_var, 5)
#           years gamesyr    bavg hrunsyr  rbisyr 
# 0.08342 0.00015 0.00001 0.00000 0.00026 0.00005 
#3. Compute the t-values for the betas.

se_betas <- sqrt(betas_var); se_betas
t_values <- betas_hat/se_betas
t_values

# output
# > t_values
#               [,1]
#         38.7518435
# years    5.6842951
# gamesyr  4.7424413
# bavg     0.8868111
# hrunsyr  0.8986418
# rbisyr   1.5004588

#4. Compute the p-values for the betas. 

for (q in t_values) {
  print(pt(q = q, df = n-k-1, lower.tail = FALSE))
}

# output
# [1] 2.09365e-128  ## intercept
# [1] 1.39379e-08   ## years
# [1] 1.544307e-06  ## gamesyr
# [1] 0.1878974     ## bavg
# [1] 0.1847333     ## hrunsyr
# [1] 0.06720246    ## rbisyr
#---------------------------------------------------------------