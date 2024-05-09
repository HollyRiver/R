#--------R Console 화면에서의 첫 명령문 입력--------

setwd("C:/Users/hollyriver/Documents/Github/R/탐색적자료분석/data")  ## set working directory
rm(list = ls())  ## clear environment data

geyser <- read.table("geyser299.txt", header = TRUE)

geyser[1:5,]

hist(geyser$waiting)
hist(waiting)  ## 할당되지 않아 직접 호출할 수 없음
quit()

#--------R 함수, 데이터 프레임, 오브젝트--------

help(read.table)  ## ?read.table

str(geyser)  ## structure
ls()  ## checking environment list

attach(geyser)  ## 소속된 변수명을 할당하지 않고도 불러올 수 있게 "붙인다"

hist(waiting)  ## Environment Data에 포함되지 않음

detach(geyser)  ## 뗀다
hist(waiting)

#-------변수와 변수 값, 벡터, 행렬, 배열-------

# 변수 할당
x <- 2  ## 수치형(numeric)
a <- "low"  ## 문자형(character)

# 벡터를 할당
x <- c(2,2,4)  ## combine
a <- c("low", "high", "high")

ls()  ## 할당한 변수가 표시됨

str(x)  ## numeric
str(a)  ## character

length(x)

# 행렬을 할당

y <- c(1.2, 3.0, 4.8)
M <- matrix(c(x, y), ncol = 2)  ## 열의 갯수(ncol)가 2인 3 by 2 행렬
M

M1 <- matrix(c(x, y), nrow = 2, byrow = TRUE)  ## 행의 갯수(nrow)가 2이고, 행을 기준으로 정렬(byrow)된 2 by 3 행렬
M1

matrix(c(x, a), ncol = 2)  ## 벡터의 원소들의 자료형은 하나여야만 함
matrix(c(x, a), nrow = 2, byrow = T)

L <- list(kor = x, math = y, grade = a)  ## 서로 다른 자료형
L

M2 <- cbind(x, y);M2  ## 묶어서 행렬을 만듦
M3 <- rbind(x, y);M3

nrow(M2)  ## 행의 수
ncol(M2)  ## 열의 수
dim(M2)   ## 행과 열

c(1,2,3,4,5,6,7,8,9,10)
1:10  ## 자동으로 벡터 생성
seq(1,10, by = 1)  ## sequence
seq(0.1, 1.2, 0.11)

rep(1, 10)  ## repute

y[2]  ## 인덱싱
y[2:3]  ## 인덱스로 벡터를 넣는 경우
y[c(2,3)]
y[c(1,3)]

M1 <- cbind(c(2,2,3), c(1.2, 3.0, 4.8))
M1[3,2]  ## 행렬의 인덱싱
M1[,2]
M1[3,]

# 배열을 할당

A <- array(c(M1, M2), c(3,2,2))  ## 3차원 배열
A

#-------연산과 논리-------

x <- c(2,2,3)
x**3 + 1  ## x^3 + 1, 개별 원소 범위에서 연산

x*y  ## 원소 간 곱, 벡터곱(내적)이 아님
x/y

round(x/y, 2)  ## 개별 원소에 함수가 적용

M <- cbind(x, y)
M

t(M)  ## transform

M1 <- t(M) %*% M  ## 행렬곱
M1

b <- c(1,2)
M1 * b  ## 같은 행끼리 곱
M1 %*% b  ## 행렬곱

solve(M1)  ## 역행렬
solve(M1) %*% M1

E <-  eigen(M1, symmetric = TRUE)  ## 고윳값과 고유벡터
E

E$vectors %*% diag(E$values) %*% t(E$vectors)  ## 행렬의 대각화


#-------논리 연산-------

g <- c(T, F, T, T)  ## 논리형 직접 입력
g

f <- c(1.2, 2.0, 3.1, 4.9)
f > 3.14  ## 파생된 경우

as.numeric(f>2.5)  ## 논리형을 정수로 바꿀 수 있음.

f[f > 3.14]  ## 논리 연산을 이용해 subset 생성

C1 <- c(T, T, F, F)
C2 <- c(T, F, T, F)

C1 & C2  ## and, 둘다 True여야 True
C1 | C2  ## or, 하나라도 True이면 True
!C1  ## inverse
!C2

#-------결측값-------

x <- c(2, 2, 3, NA)
mean(x)  ## 그냥 하면 NA가 나온다.
mean(x, na.rm = TRUE)  ## NA를 제거할 것임을 명시

0/0  ## 정의하지 않음
1/0  ## 무한

10^seq(100, 1000, 100)  ## 10의 400제곱부터는 Inf로 표기되었다.

#-------요인-------

species <- c(1,3,2,3)  ## 순서형 자료를 범주형으로 변환해야 할 때
species_f <- factor(species, levels = 1:3)  ## levels에 species의 값들을 넣어준다.

levels(species_f) <- c("califonia", "losangeles", "virginia")  ## levels의 값을 바꾼다.

species_f

table(species_f)  ## 범주형으로 저장된 자료의 빈도 수를 구해야 할 때 사용(순서있는 범주형의 경우 ordered())

#-------자료 변환과 데이터 부분세트-------

x <- c(45, 32, 34, 28, 80)
y <- c(23, 37, 12, 76, 65)
d2 <- list(kor = x, eng = y)

d2a <- transform(d2, tot = kor + eng)  ## 첫 번째 파라미터에는 변환될 개체를, 이후에는 추가할 변수를 입력해준다. (assign()과 유사)
d2a

d3 <- subset(d2a, tot > 100)  ## create subset
d3

#-------순서정렬과 순위-------

x <- c(12, 6, 4, 7, 8)
sort(x)  ## 정렬

order.x <- order(x)  ## 정렬해야 할 때 와야할 원소의 인덱스 표시
order.x

x[order.x]  ## sort(x)와 같은 결과
y[order.x]  ## 같은 길이의 벡터 y를 같은 순서로 재배열

rank(x)  ## 작은 순서대로 순위 표시

x1 <- c(12, 12, 4, 7, 8)
rank(x1)  ## 중복되는 수가 있을 시 기본적으로 평균으로 표시
rank(x1, ties.method = "first")   ## 묶는 방법을 먼저 나온 것을 우선시
rank(x1, ties.method = "random")  ## 같은 수는 무작위로 순위를 제공

#-------apply 류-------

setwd("C:/Users/hollyriver/Documents/Github/R/탐색적자료분석/data")
geyser <- read.table("geyser299.txt", header = TRUE)

apply(geyser, 2, median)  ## data, axis, function 순서대로 입력, R에서는 axis가 1부터 시작함(행)

f <- function(x) {
  x**2
}

apply(geyser, 1, f)  ## 개별 원소에도 적용할 수 있다.

hist(apply(geyser, 1, sum))  ## 시리즈의 형태가 되어 히스토그램으로 나타낼 수 있다.
summary(apply(geyser, 1, sum))

lapply(geyser, median)  ## 리스트의 형태로 저장, key값이 필요하기 때문에 열로 한정지음
apply(geyser, 2, median)

#-------루프(loop)-------

a <- rep(1, 20)

for (i in 3:20) a[i] = a[i-1] + a[i-2]  ## 반복 수행할 작업이 하나인 경우

a[a < 100]

a <- rep(1, 20)
b <- rep(1, 20)

for (i in 3:20) {
  a[i] = a[i-1] + a[i-2]
  b[i] = b[i-1] + (-1)**(i-1)*b[i-2]
}

a[a < 100]
b[b < 100]

#-------난수 생성(random number generation)-------

par(mfrow = c(1,1))

x <- runif(400, -1, 1)  ## 범위가 [-1, 1]인 uniform distribution에서 400개의 랜덤샘플을 뽑음
hist(x)

x <- rnorm(400)   ## standard normal distribution에서 400개의 랜덤샘플을 추출
hist(x)

x <- rbinom(1000, 10, 0.5)   ## n이 10, p가 0.5인 binomial distribution에서 1000개의 랜덤샘플을 추출
hist(x)
table(x)  ## 5가 제일 많음

x <- rpois(1000, 5)    ## lambda가 5인 poisson distribution에서 1000개의 랜덤샘플을 추출
hist(x)
table(x)

#-------R 그래픽스 : 산점도-------

attach(geyser)
colnames(geyser)

plot(duration ~ waiting)  ## 기본으로 산점도 표시

## 여러가지 파라미터
plot(duration ~ waiting, xlim = c(40, 110), ylim = c(1, 6),
     xlab = "waiting time (min)", ylab = "duration (min)", main = "Geyser")

plot(duration ~ waiting, xlim = c(40, 110), ylim = c(0.8, 6),
     xlab = "waiting time (min)", ylab = "duration (min)", main = "Geyser", type = "n")
text(x = waiting, y = duration, cex = 0.5)  ## type = "n" : none, null. 그래프를 그리지 않음. 즉, figure만 생성하고 그 후 텍스트를 덧씌운 형태

#-------R 그래픽스 : 다중 프레임-------

x1 <- rbeta(400, 1, 1)  ## beta distribution에서 400개의 랜덤샘플을 추출
x2 <- rbeta(400, 2, 2)
x4 <- rbeta(400, 4, 4)
x8 <- rbeta(400, 8, 8)

dev.new()
par(mfrow = c(2,2))  ## set of query graphical parameters, 그래프 모양을 조절하는 그래픽 파라미터를 조작. multiple frame을 column 방향으로 구성하겠다.
hist(x1, breaks = seq(0, 1, 0.1), freq = FALSE, ylim = c(0, 3))  ## breaks로 각 구간의 크기를 정할 수 있다.
hist(x2, breaks = seq(0, 1, 0.1), freq = FALSE, ylim = c(0, 3))  ## freq로 빈도수로 할 것인지 비율로 할 것인지 전환할 수 있다.
hist(x4, breaks = seq(0, 1, 0.1), freq = FALSE, ylim = c(0, 3))
hist(x8, breaks = seq(0, 1, 0.1), freq = FALSE, ylim = c(0, 3))

#-------그래프를 겹쳐 그리기-------

par(mfrow = c(1, 1))  ## 위에서 정의했던 파라미터를 원래대로 바꿔줌
x <- rt(1000, 5)
hist(x, freq = FALSE, xlim = c(-5, 5), ylim = c(0, 0.4),
     nclass = 20, xlab = "simulated observation", main = expression("t ~ (5)"))
m <- mean(x)
s <- sd(x)
curve(dnorm(x, m, s), add = TRUE)  ## 기존 그래프에 추가

#-------사용자 정의 함수-------

skew_and_kurto <- function(x) {
  num1 <- mean((x - mean(x))**3)    ## numer
  denom1 <- (mean((x - mean(x)**2)))**1.5   ## denominator
  num2 <- mean((x - mean(x))**4)
  denom2 <- (mean((x - mean(x))**2))**2
  
  skew <- num1 / denom1
  kurto <- num2 / denom2 - 3
  
  return(c(skew, kurto))
}

t5 <- rt(1000, 5)
round(skew_and_kurto(t5), 3)

z <- rnorm(1000)
round(skew_and_kurto(z), 3)

u <- runif(1000)  ## 0~1
round(skew_and_kurto(u), 3)

#-------데이터 세트 병합하기-------

data1 <- data.frame(id = c(23, 4, 78, 54),
                    mid = c(43, 56, 29, 99))
data1

data2 <- data.frame(id = c(4, 23, 54, 70),
                    final = c(77, 2, 19, 31))
data2

data1_2 <- merge(x = data1, y = data2,
                 by.x = "id", by.y = "id")
data1_2

data1_2 <- merge(x = data1, y = data2,
                 by.x = "id", by.y = "id", all = TRUE)
data1_2

#-------데이터 세트 분할하기-------

gr <- c(1, 2, 1, 1, 2)
gr <- factor(gr)
levels(gr) <- c("low", "high")  ## 벡터에 이름을 할당

score <- c(98, 82, 45, 23, 74)
score_split <- split(score, gr)  ## 단순 벡터를 할당해도 정상 작동
score_split

score_split$low
score_split$high

score1 <- score[gr == "low"]
score1
score2 <- score[gr == "high"]
score2

#-------외부 데이터 파일 읽기-------

setwd("C:/Users/hollyriver/Documents/Github/R/탐색적자료분석/data")
read.csv("score1.csv", header = TRUE)

library(foreign)  ## SPSS, SAS 데이터 파일을 읽을 수 있음.
ee <- read.spss("EEstock2000.sav")
str(ee)

#-------R 작업 관리-------

ls()  ## 오브젝트 리스트 확인

rm(temp, x)
ls()

rm(list = ls()) ## 오브젝트 리스트에 해당하는 것을 모두 제거
ls()

x <- rbinom(299, 1, 0.5)  ## 확률이 0.5인 베르누이 시행을 299회 반복
geyser <- read.table("geyser299.txt", header = TRUE)
geyser_x <- cbind(geyser, x)
write.table(geyser_x, "geyser_2.txt")  ## 저장된 데이터를 파일로 저장

sink("geyser.out")  ## 앞으로의 출력을 파일(geyser.out)에 보냄, 파일이 없으면 생성
summary(geyser_x)
sink()              ## 앞으로의 출력을 콘솔에 보냄