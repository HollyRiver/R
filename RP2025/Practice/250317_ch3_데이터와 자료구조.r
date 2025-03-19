## Date : 2025-03-17
## Author : HollyRiver

## Chapter 3 - 데이터와 자료구조

##----------3.3 Vector----------
### 1. generate Vector
v1 <- c(1,2,3,4,5) ## 숫자형 벡터
v2 <- c('a', 'b', 'c') ## 문자형 벡터
v3 <- c(T, F, F) ## 논리형 벡터
v4 <- c(1,2,3,'a','b','c') ## 문자가 숫자가 될 수 없으므로, 기본적으로 문자형 벡터

#### sequence
v5 <- 1:10
v6 <- seq(1, 10, 2) ## 1부터 10까지 공차를 2로 하는 수열
v7 <- rep(1:5, 3) ## 1:5를 3번 반복. 기본적으로 times를 설정
v8 <- rep(1:5, each = 3) ## each elements를 n번 반복

seq(10) # ????? 왜 10:1 아님
seq(length.out = 10) # 얜 왜 디폴트 뚫고 1:10임
rep(1:5, 3, each = 3) ## 111222333444555111222333444555...

### 2. vector indexing
v <- c(6,8,1,9,7)
v[1] ## 인덱스는 1부터 시작;;
v[6] ## NA : Out of range error는 안뜨네.

v[1:3] ## 슬라이싱
v[-5] ## 뒤를 기준으로 하는 게 아니라... 해당 인덱스만 제외하고 추출
v[c(T, T, F, T, F)] ## TRUE에 해당하는 인덱스 값 추출

### 3. 벡터 산술연산
v9 <- c(3, 7, 8)
v10 <- c(4, 2, 8)

v9 + 2  ## 벡터 + 스칼라 산술연산? -> 사실상 동일 차원의 벡터 간 연산. 벡터라이징
v9 + v10  ## 동일한 크기 벡터 간 산술연산

v9 + c(10, 5)  ## warning. v9 + c(10, 5, 10)과 동일하게 처리됨. 재활용 규칙 사용

#### 벡터에 적용가능한 함수
sum(1:10)
mean(1:10)
median(1:10)
max(1:10)
min(1:10)
var(1:10)
sd(1:10)
length(1:10)

### 4. 벡터 비교연산
v11 <- 1:10
v11 >= 5  ## 각 모든 원소에 대해서 비교연산자를 적용
v11[v11 >= 5] ## 5 이상인 값 추출
## ┌ length(v11[v11 < 5]) ## 이렇게 안쓰는 이유
sum(v11 < 5) ## 논리값이 산술연산에 사용되는 경우. 5 미만인 값의 개수
sum(v11[v11 < 5]) ## 5 미만인 값의 합계. 1+2+3+4

### 5. factor
seasons <- c('spring', 'fall', "winter", "summer", "summer", "spring")
seasons_factor <- factor(seasons)
seasons_factor  ## 문자열을 따옴표가 감싸지 않고, factor가 가질 수 있는 범주인 levels가 표시됨.

levels(seasons_factor)  ## levels를 문자형 벡터로 산출. 기본 설정은 사전순

seasons_factor[7] <- "autumn"
seasons_factor  ## 일단 들어가긴 함. <NA>로 들어감.

table(seasons_factor) ## 빈도표 생성
barplot(table(seasons_factor))

#### 팩터의 levels 순서 지정
szn_fct2 <- factor(seasons, levels = c("spring", "summer", "fall", "winter"))
szn_fct2

table(szn_fct2)
barplot(table(szn_fct2))

##----------3.4 Matrix and Array----------
### 1. 행렬 생성
m1 <- matrix(1:20, nrow = 4, ncol = 5)
m1 ## 기본적으로 열부터 채움

m1[1,]
m1[3, 3]

m2 <- matrix(1:20, nrow = 4, byrow = TRUE)
m2 ## 행부터 채울 수 있음

matrix(1:20, nrow = 4, ncol = 3) ## 행렬이 너무 작으면 뒤가 짤림

#### 행/열에 이름 붙이기...???
score <- matrix(c(80, 67, 74,
                  82, 95, 88,
                  75, 84, 82,
                  95, 83, 76),
                nrow = 4, byrow = TRUE) ## 이대로 들어가게 하려고 TRUE로...

dim(score)
nrow(score) ## dim(score)[1]
ncol(score) ## dim(score)[2]

rownames(score) ## NULL : 정의되지 않음
colnames(score)

rownames(score) <- c("Kim", "Lee", "Park", "Choi")
colnames(score) <- c("Kor", "Eng", "Math")

score ## 행의 이름과 열의 이름이 할당됨.

### 2. 행렬 인덱싱
m <- matrix(1:15, nrow = 3)
m[2, 4] ## 하나를 추출
m[3,] ## 한 행을 추출
m[, 1] ## 한 열을 추출
m[c(1,3),] ## 슬라이싱. 파이썬과 달리 그냥 벡터로 묶어서 넣으면 됨.
m[,c(2,4,5)]


m[-2,] ## 미친 경우. 빼고 호출하는 거임. 뒤에서부터 호출 못함.

#### 비교연산자
v <- 1:5
v > 2 ## 벡터의 경우 각 원소마다 적용

m > 7 ## 행렬도 각 원소마다 적용

### 3. 행렬 산술연산
m2 <-  matrix(1:20, nrow = 4)
m3 <- matrix(21:40, nrow = 4)
m4 <- matrix(1:10, nrow = 5)
v1 <- c(1:4)

m2 + m3 ## 기존 행렬의 합연산과 동일
m2 - m3 ## 기존 행렬의 합연산과 동일
m2 * m3 ## 행렬곱과 다름, 같은 위치에 있는 애들끼리 곱함
m2 / m3 ## 같은 위치에 있는 애들끼리 나눔

m2 %*% m4 ## 행렬곱 : (4, 2) matrix

m2 + c(1:3) ## 열 순서대로 더해주는듯

### 4. 특수행렬
diag(1, nrow = 3, ncol = 3)   ## 단위행렬
matrix(0, nrow = 3, ncol = 3) ## 영행렬, 원소 수가 모자라도 생성됨
diag(c(1,2,3))  ## 대각행렬. 나머지는 다 0으로 채워줌
matrix(c(1,2,2,1), nrow = 2)  ## 대칭행렬은 그냥 만들어야 함 ㅇㅇ

A <- matrix(1:6, nrow = 2)
t(A)  ## 전치행렬

B <- matrix(1:4, nrow = 2)
solve(B)  ## 역행렬
det(B)    ## 행렬식

B %*% solve(B) ## 단위행렬이 나옴. 잘 해줬음.