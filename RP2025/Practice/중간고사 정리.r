#----------2. R 기초----------
## 1. 산술연산
1+2
1-2
1*2
1/2
1%%2
1^2

## 2. 산술연산 함수
log(2) ## 자연로그
sqrt(2)
abs(-2)
factorial(2)
sin(2*pi)
cos(pi/2)
tan(pi/2)

## 4. 자료형
as.numeric("1")
as.character(1)
as.logical("TRUE")
FALSE
T
F
NULL ## 정의되지 않음
NA   ## 결측치
NaN  ## 연산 불가

## 5. 비교연산
a <- 1
b <- 2

a > b
a >= b
a < b
a <= b
a != b
a == b

## 6. 논리연산
c <- 3
d <- 4

(a > b) & (c < d) ## FALSE
(a > b) | (c < d) ## TRUE

#----------3. 데이터와 자료구조----------
## 3. 벡터
v1 <- c(1, 2, 3, 4, 5)
v2 <- c('a', 'b', 'c')
v3 <- c(TRUE, FALSE, T)
v4 <- c(1, 2, 3, 'a', 'b') ## character vector

v5 <- 1:10
v6 <- seq(1, 10, 2)
v7 <- rep(1:5, times = 5) ## default arg setting
v8 <- rep(1:5, each = 5)  ## 각 원소를 반복하면서 붙임