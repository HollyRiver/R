
rm(list = ls(all=T)) # This code clears all. 
setwd("F:\teaching\Econometrics\lecture_2023\R_code")

#Please reset your path for the data
mydata<-read.csv("hprice2.csv", header = TRUE) 

ls(mydata) #list of variables
head(mydata)

# dependent variable
lprice <- mydata$lprice #log(y) variable

#explanatory variables
lnox <- mydata$lnox     #log(nox)
dist <- mydata$dist     #distance
ldist <- log(dist)      #log(dist)
rooms <-mydata$rooms   
stratio <-mydata$stratio


#plot-----------------------------
dev.new()
plot(lnox, lprice, pch=16, col="blue", cex=1.5)

#Stacked data
Y <- lprice
X <- cbind(1, lnox, ldist, rooms, stratio)

head(X)
tail(X)

k<-ncol(X)-1 #number of explanatory variables except for 1
k            

n<-length(lprice) #number of home prices
n

#Estimation of the multiple regression model--------------------------------------
tX <- t(X) #transpose X
beta.hat <- solve(tX %*% X) %*% tX %*% Y  #solve((tX %*% X)=inverse matrix of (tX %*% X)
beta.hat


#Compute the variances of estimated betas-----------------------------------------
sigma2_hat <- t(Y-X%*%beta.hat)%*%(Y-X%*%beta.hat)/(n-k-1) #5=number of parameters 
sigma2_hat #error variance

class(sigma2_hat)

#Compute the standard errors (se) for betas---------------------------------------
inv_txx=solve(tX%*%X)
var_betas<-as.numeric(sigma2_hat)*inv_txx #variance-covariance matrix
var_betas
round(var_betas,6)


#SSR---------------------------------------------------------------------------
U.hat<-Y-X%*%beta.hat
SSR<-t(U.hat)%*%U.hat

#SSE---------------------------------------------------------------------------
Y.hat<-X%*%beta.hat
SSE<-t(Y.hat-mean(Y.hat))%*%(Y.hat-mean(Y.hat))
SSE

#SST---------------------------------------------------------------------------
SST<-t(Y-mean(Y))%*%(Y-mean(Y))
SST

#R-squared
R_squared<-SSE/SST
R_squared  



#---------------standard error of beta--------------------------------------------
se_beta<-sqrt(diag(var_betas))
se_beta

#--------------------------t-statistic------------------------------------- 
t_beta<-beta.hat/se_beta
t_beta

#cumulative density function (CDF)---------------------------------------------
pt(-2,df=n-k-1) #area between -infinity and -2 
pt(-3,df=n-k-1) #area between -infinity and -3 

#p-values for two-sided tests------------------------------------------------------
#p-values for betas
p_beta<-2*pt(-abs(t_beta),df=n-k-1)
p_beta

#print the estimates of the model parameters, standard errors, and t-values
summary.output<-data.frame(beta.hat, se_beta, t_beta, p_beta)
summary.output


#Find c: Critical values-------------------------------------------------------
qt(0.05,df=n-k-1)
qt(c(0.025, 0.975),df=n-k-1) #significance level alpha=0.05 for two sided tests
qt(c(0.05, 0.95),df=n-k-1)   #significance level alpha=0.10 for two sided tests
qt(c(0.10, 0.90),df=n-k-1)


#---------------two-sided test-------------------------------------------------
#See page 15 of our lecture slides
alpha<-0.05 #significance level 
crit1<-qt(1-alpha/2, df=n-k-1)
crit1  # c value

#See page 16 of our lecture slides
alpha<-0.10 #significance level 
crit2<-qt(1-alpha/2, df=n-k-1)
crit2  # c value

#one-sided test--------------------------------
#See page 17 of our lecture slides
alpha<-0.05 #significance level
crit3<-qt(alpha, df=n-k-1)
crit3  # c value




#----------lm function for multiple regression analysis------------------------

out <- lm(log(price)~log(nox)+log(dist)+rooms+stratio,data=mydata);
output<-summary(out)
output

output$coefficients

output$coefficients[1,1] #beta0
output$coefficients[1,2] #se for beta0
output$coefficients[1,3] #t-statistic for beta0
output$coefficients[1,4] #p-value for beta0

output$coefficients[2,1] #beta1
output$coefficients[2,2] #se for beta1
output$coefficients[2,3] #t-statistic for beta1
output$coefficients[2,4] #p-value for beta1

Rsquared<-output$r.squared
Rsquared

#----------------Consider crime with the other variables------------------------- 
out <- lm(log(price)~log(nox)+log(dist)+rooms+stratio+crime,data=mydata);
output<-summary(out)
output

output$coefficients
