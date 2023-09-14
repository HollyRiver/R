rm(list = ls())

a<-1+1
a

b<-2^3
b

c<-2*3
c

d<-4/2
d

#####################################
x <- c(1, 3, 4, 8, 9)
x

y<-x+2
y

z<-x^2
z

######## some functions #############
sum(x)
mean(x)  
sd(x)   #standard deviation

log(x)
exp(x)
max(x)

length(x)

k<-length(x)
k

########## sequence #################

d<- 1:10
d

d2<-seq(from=1, to=10, 1)
d2

d3<-seq(from=10, to=0, -2)
d3

e<- -3:5
e

k<-5:1
k

j<-2*x+3
j

l<-5:1*x
l

######### [ ] ############
#x <- c(1, 3, 4, 8, 9)

x[5]

a<-x[c(1,4)] #Take the 1st and 4th numbers.
a

b<-x[-c(2,3,5)] # Take the numbers except for the 2th, 3th, and 5th elements. 
b

#########################
a <- rep(1, 10) #replicate 1 ten times
a

#####################
years <- 2000:2019
years

head(years)
tail(years)

years.q<-seq(from=2000.0, to=2019.75, by=0.25)
years.q


######################## matrix #############################
A <- matrix(1:6, nrow = 2, byrow=TRUE) #nrow=number of rows
A

A2 <- matrix(1:6, nrow = 2, byrow=FALSE) #nrow=number of rows
A2

B <- matrix(1:6, ncol = 3, byrow=FALSE)
B

B2 <- matrix(1:6, ncol = 3)
B2

t(A) #transpose of A

dim(A)

nrow(A)

ncol(A)


D1<-A[1:2, c(1,3)] #extract the numbers corresponding to the 1st and 2nd rows 
                   #and the first and third columns
D1

D2<-A[1, ]
D2

D3<-A[ ,2]
D3

D4<-A[2,1]
D4


#####################
inverseD1<-solve(D1) #inverse matrix of D1
inverseD1

#####################
diag(1,4) #4by4 

diag(4,4) #4by4

diag(4,2) #2by2

u.mat<-diag(1,2) %*% diag(1,2) #matrix multiplication, %*%
u.mat

#####################
D5<-rbind(D1, diag(4,2))
D5

D6<-cbind(D1, diag(4,2))
D6
#####################
#x <- c(1, 3, 4, 8, 9)
names(x) <- c("a", "b", "c", "d", "e")
x

rownames(D1)<-c("row_1", "row_2")
colnames(D1)<-c("col_1", "col_2")
D1


#####################
rnorm(5) #random draws from the standard normal distribution with mean=0 and sd=1
rnorm(5)

rnorm(5, mean = 100, sd=1) #random draws from the normal distribution with mean=100 and sd=1
rnorm(5, mean = 100, sd=1)

runif(10, min=0, max=1) #runif( ) generates 10 random numbers from a uniform distribution


#####################
mylist <-list(sample=rnorm(5),
              family="normal distribution",
              parameters=list(mean=0, sd=1)
              )
mylist
mylist[]

mylist$sample
mylist[[1]]
mylist[["sample"]]


mylist$family
mylist[[2]]

mylist$parameters
mylist[[3]]

mylist$parameters$mean
mylist[[3]]$mean

mylist$parameters$sd
mylist[[3]]$sd


#####################
lt<-c("I will get A in this class")
lt


########## Logic: TRUE or False ###########
x <- c(1, 3, 4, 8, 9)

x<4 
(x<4)

x<=4

!(x<4) #opposite of (x<4)

x>3 | x<=4 #If x>3 or x<=4, return TRUE.

x>3 & x<=4 #If x>3 and x<=4, return TRUE.

x[which(x>3 & x<=4)] #Since the 3rd satisfies the conditions, 
                     #which(x>3 & x<=4) returns 3. Therefore, x[which(x>3 & x<=4)]
                     #prints x[3]. Note that x[3] is 4. 
x[3]

1==1 #If equal, return TRUE.

1!=1 #If not equal, return TRUE.

1>=2 #False


#-----------if else------------------------------------
if (rnorm(1)>0) {
    sum(x)
    } else {
    mean(x)
    }


#----------for loops--------------------------
#x <- c(1, 3, 4, 8, 9)
x[1] #Extract the 1st element in x
x[3] #Extract the 3rd element in x

y<-rep(0,4)
y

for(i in 2:5) {
  y[i-1]<-x[i]-x[i-1]
}
y

#------------------------------------
sum <- 0
for (i in 1:10){
  sum <- sum + i
}
sum
print(sum)

#-----------------------------------
save.y <- 0
sum <- 0
for (i in 1:10){
  sum <- sum + i
  save.y <- c(save.y, sum)
  print(sum)
}
sum
save.y

#-----------------------------------
sum <- 0
for (i in seq(2,10,2)){
  sum <- sum + i
}
sum

#---------------------------
sum <- 0
for (i in 1:10){
  sum <- sum + 1/i
}
sum


#------------while loop-------------------

sum <- 0
i <- 1
while (i<=10){
  sum <- sum + i
  i <- i + 1
}
sum

#-----------------------------------------
sum <- 0
i = 1
while (i<=10){
  sum <- sum + i
  i <- i + 2
}
sum

#---------define a function---------------
f <-function(x){
  (x-2)^2
}
f(4)

x <-seq(-10,15 , length=1001) #seq(from = -10, to = 15, by = 0.025)

head(x)
tail(x)
length(x)

#----------plot y-------------------------
y <- f(x)
y

dev.new()
plot(x,y, type="l", col="blue") #points: type="p"


#---------integration---------------------
f <-function(x) {
  x^3+3*x^2+3*x+1
} 
x <- seq(-5,5,0.01) ## 수를 나열하는 함수(수열), same as seq(-5, 5, length = 1001)
length(x)
y <-f(x)

dev.new()

plot(x,y, type="l", col="red", lwd=2)
## plot type = line, color = red, line_widge = 2

f12<-integrate(f, lower = 1, upper = 2) ## integrate function "f"
f12   ## > 16.25 with absolute error < 1.8e-13 : 실제 값과의 차이는 0.000000000000018보다 작음.


#---------differentiation-----------------
#install.packages("Deriv")
install.packages('Deriv')
library(Deriv)  ## derivative 미분, 도함수

f

x <- seq(-10, 10, by = 0.1)
y <- f(x)

f1<-Deriv(f)
f1
f1(1)

dev.new()
plot(x, f1(x), type ='l', col = 'red', lwd = 2)
plot(x, y, type ='l', col = 'red', lwd = 2)

?Deriv

f2<-Deriv(f1)
f2

#----------------univariate normal distribution-------------------------------- 
mu<-0
sigma<-1

#PDF
normal_pdf <- function(x) {
  (1/sqrt(2*pi*sigma^2))*exp( -((x-mu)^2)/(2*sigma^2) )
}

## 염병할 표준정규분포 확률밀도함수 직접 입력해야 되는거 맞냐. cf) 그냥 적분 시각화하려고 한듯?

mu <- 0
sigma <- 1

normal_pdf <- function(x) {
  ((1/sqrt(2*pi*sigma^2))*exp(-(1/2)*((x-mu)/sigma)^2)) ## sqrt() : square root, pi : pie, exp() : exponence
} ## probability distribution function

x <- seq(-5,5,0.01)
y <- normal_pdf(x)
y
#Plot normal distributions 
dev.new()
plot(x,y, type="l", col="red", lwd=2) #lty=1,

?plot()

f.norm<-integrate(normal_pdf, lower = -1.96, upper = 1.96)
f.norm  ## console ; 0.9500042 with absolute error < 1e-11

#-----------for loop: integration-----------------------------------------------

## 구분구적법 직접 해보기

x <- seq(-1.96, 1.96, by = 0.0000001)
integrated_val <- 0

'''
## 틀린 코드
for (i in (length(x)-1)) {
  integrated_val <- integrated_val + normal_pdf(x[i])*0.0001
}

> 해설 :  i가 포함되는 곳이 행렬이 아닌 한 개의 숫자임
'''

for (i in 1:(length(x)-1)) {  ## length(x)만큼 점을 나누었으므로 하나를 빼주어야 범위내 사각형의 넓이를 구할 수 있음
  integrated_val <- integrated_val + normal_pdf(x[i])*0.0000001
}

## 연산에 상당한 시간이 걸린다.

print(integrated_val)   ## colsole : 0.9500042. integrate(normal_pdf, lower = -1.96, upper = 1.96)과 결과가 동일

integrate_quadrature <- function(func, lower, upper) {  ## 구분구적법으로 미분하는 함수
  seq_vector <- seq(lower, upper, by = 0.000001)
  integrated_val <- 0
  
  for (i in 1:(length(seq_vector)-1)) {
    integrated_val <- integrated_val + 0.000001*func(x[i])
  }
  integrated_val
}

integrate_quadrature(normal_pdf, -1.96, 1.96)   ## 왜 결과값이 안나올까



x <- seq(-1.96,1.96,0.0000001)
sum<-0
length(x)
for (i in 1:(length(x)-1)){
  sum<-sum+0.0000001*normal_pdf(x[i])
}
print(sum)

#------------Scatter Plot-------------------------------------------------------

n<-1000
x<-4+rnorm(n,mean=1,sd=5)
y<-1+2*x+rnorm(n,mean=0,sd=4)

## 함수 y = 2x + 1로 회귀되는 원소들을 만드는 수식

dev.new()
plot(x,y, pch=16, col="blue",  ## pch = 16 : marker = filled circle, if select pch option, output scattor plot -> 아닌듯?
     main=expression(paste("Sampling under ", beta[0], 
                           "=1", " ", "and", " ", beta[1], "=2")))
text(6, -15, "scatter plot", cex=1.5) ## add texts in dev where (6,-15), charactor expansion = 1.5
abline(a=1,b=2, col="red", lwd=3) ## line with parameter a(beta[0]), b(beta[1]). format is y = a + bx

dev.new()
plot(x,y, col="blue",
     main=expression(paste("Sampling under ", beta[0], 
                           "=1", " ", "and", " ", beta[1], "=2")))

## plot() 함수에서 type을 지정하지 않으면 디폴트 값은 "p"(point), 즉, 스캐터 함수로 산출함.

## main = 제목을 지정하는 옵션
## expression() 안에 포함된 표현들을 살려서 charactor로 산출하는 함수. 즉, 마크다운으로 적힌 문자열을 변환시켜준다.
## paste() 여러 개체들을 붙여서 하나의 charactor로 산출한다.

paste(c(1:4), 'testing')  ## console : [1] "1 testing" "2 testing" "3 testing" "4 testing". 꼭 그런 것만은 아닌가보다.