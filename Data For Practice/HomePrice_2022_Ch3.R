rm(list = ls(all=T)) # This code clears all. 이런 건 안나옴
setwd("C:\\Users\\hollyriver\\Documents\\Github\\R\\Data For Practice")  ## set working directory, 작업할 폴더 설정

#Please reset your path for the data
mydata<-read.csv("hprice2.csv", header = TRUE)   ## csv 파일을 데이터프레임으로 불러온다. setwd하지 않았으면 직접위치 지정
## 첫 행은 헤더, 변수명으로 받아온다.

typeof(mydata)
dim(mydata)
mydata


colnames(mydata)

ls(mydata) #list of variables, 첫 행 이름의 리스트
head(mydata)  ## 초기 6개 행만 output

# dependent variable  ## 단순히 열들을 할당하는 메소드
lprice <- mydata$lprice #log(y) variable  ## 데이터프레임을 불러올 때, df.colname에서 .처럼 $으로 특정 원소를 불러온다.
head(mydata$price)
head(mydata$lprice)

#explanatory variables
lnox <- mydata$lnox     #log(nox)  ## 대기오염 정도
head(mydata$lnox)

dist <- mydata$dist     #distance
ldist <- log(dist)      #log(dist)
rooms <-mydata$rooms   
stratio <-mydata$stratio  ## student teacher ratio

## 4개의 설명변수로 집값을 설명하려고 한다.



#plot-----------------------------
dev.new()
plot(lnox, lprice, pch=16, col="blue", cex=1.5)  ## 산점도, x, y, 마커 종류, 색상, 사이즈(chracter expansion)

#Stacked data
Y <- lprice  ## 추정하고자 하는 모형
X <- cbind(1, lnox, ldist, rooms, stratio)  ## cbind, 행렬 X를 만든다. 1은 절편을 의미

head(X)
tail(X)

dim(X)

k<-ncol(X)-1 #number of explanatory variables except for 1
k

n<-length(lprice) #number of home prices ## 이건 아무 열이나 싸잡아서 내놔도 똑같긴 함
n

#Estimation of the multiple regression model--------------------------------------
tX <- t(X) #transpose X
beta.hat <- solve(tX %*% X) %*% tX %*% Y  #solve((tX %*% X)=inverse matrix of (tX %*% X)  ## 행렬곱 : %*%
beta.hat


## 실습
mydata = read.csv("C:\\Users\\hollyriver\\Documents\\Github\\R\\Data For Practice\\hprice2.csv", header = TRUE)
ls(mydata)

X1 = mydata$dist
X2 = exp(mydata$lnox)
X3 = mydata$rooms
X4 = mydata$stratio

XX = cbind(1, X1, X2, X3, X4)

#Compute the variances of estimated betas-----------------------------------------
sigma2_hat <- t(Y-X%*%beta.hat)%*%(Y-X%*%beta.hat)/(n-k-1) #5=number of parameters 
## sigma^2_hat = sigma(y-yhat)^2

beta_hat = (solve(t(X)%*%X))%*%t(X)%*%Y

t(Y - X%*%beta_hat)%*%(Y - X%*%beta_hat)  ## SSE
t(Y - X%*%beta_hat)%*%(Y - X%*%beta_hat) / (n-k-1)  ## MSE

sigma2_hat #error variance  ## matrix

class(sigma2_hat)


#Compute the standard errors (se) for betas---------------------------------------
inv_txx=solve(tX%*%X)  ## covariance를 구하기 위해, sigma*(X'X)^-1
var_betas<-as.numeric(sigma2_hat)*inv_txx #variance-covariance matrix  ## type을 바꿈. as.numeric() > matrix를 숫자로
var_betas
round(var_betas,6)  ## 반올림 / beta[0] ~ beta[4]의 표준오차

df <- data.frame(X1, X2, X3, X4, Y)
colnames(df) = c('dist', 'nox', 'rooms', 'stratio', 'price')


as.numeric(sigma2_hat)*solve(t(X)%*%X)


#SSR---------------------------------------------------------------------------
U.hat<-Y-X%*%beta.hat  ## y - yhat summation
SSR<-t(U.hat)%*%U.hat

#SSE---------------------------------------------------------------------------
Y.hat<-X%*%beta.hat  ## yhat - ybar
SSE<-t(Y.hat-mean(Y.hat))%*%(Y.hat-mean(Y.hat))
SSE

#SST---------------------------------------------------------------------------
SST<-t(Y-mean(Y))%*%(Y-mean(Y))  ## y - ybar
SST

#R-squared
R_squared<-SSE/SST
R_squared  ## matrix, as.numeric해야 가용함



#---------------standard error of beta--------------------------------------------
se_beta<-sqrt(diag(var_betas))  ## 분산-공분산 행렬의 대각원소
se_beta

#--------------------------t-statistic------------------------------------- 
t_beta<-beta.hat/se_beta  ## 각 t값
t_beta


#cumulative density function (CDF)---------------------------------------------
pt(-2,df=n-k-1) #area between -infinity and -2 
pt(-3,df=n-k-1) #area between -infinity and -3 

pt(2, df = n-k-1, lower.tail = FALSE)

#p-values for two-sided tests------------------------------------------------------
#p-values for betas

p_beta <- 2*pt(abs(t_beta),df=n-k-1, lower.tail = FALSE)
p_beta
round(p_beta, 6)

model <- lm(formula = price ~ stratio + nox + rooms + dist, data = df)
summary(model)

#print the estimates of the model parameters, standard errors, and t-values
summary.output<-data.frame(beta.hat, se_beta, t_beta, p_beta)
summary.output

colnames(mydata)

df <- data.frame(
  log(mydata$nox),
  log(mydata$dist),
  mydata$rooms,
  mydata$stratio,
  mydata$price
)

model <- df

log(mydata$nox)
log(mydata$dist)
mydata$rooms
mydata$stratio

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
