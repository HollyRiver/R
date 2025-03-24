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

### 5. 행렬 결합
m4 <- matrix(1:12, nrow = 4)  ## 4*3
m5 <- matrix(13:18, nrow = 2) ## 2*3

m6 <- rbind(m4, m5)
## rbind(m5, m4)

## 행렬에 벡터도 결합할 수 있음 : 행의 개수가 동일하면
v <- 1:6
m7 <- cbind(m6, v)  ## 해당 열의 경우, 벡터의 변수명이 지정되어 있으므로 열이름
colnames(m7)

colnames(m7) <- NULL
colnames(m7)

### 6. 배열
arr <- array(1:12, dim = c(2,2,3))
arr

##----------3.5 List----------
### 1. 리스트 생성
myinfo <- list(name = "Kim",
               age = 25,
               smoking = TRUE,
               score = c(70, 85, 90)
)

myinfo$name
myinfo$score[1]

### 2. 리스트 인덱싱
is(myinfo[[2]]) ## 리스트 원소만 호출함. is를 이용하여 타입을 나타낼 수 있음
is(myinfo[2])   ## 리스트 그대로 호출함

myinfo$age      ## 보통 이렇게 함


##----------3.6 DataFrame----------
### 1. 데이터프레임 생성
df1 <- data.frame(name = c("Kim", "Lee", "Park", "Choi"),
                  age = c(24, 25, 22, 27),
                  btype = factor(c("A", 'B', 'O', 'B'), levels = c("A", "B", "AB", "O")),
                  smoking = c(T, F, T, T)
)

df1$btype

## 데이터 추가
# data.frame(df1,
#            pet = c("dog", "cat", "bird", "dog"))  ## 이렇게 써도 됨

df2 <- cbind(df1, c("dog", "cat", "bird", "dog"))

colnames(df2)[5] <- "pet"
df2

### 2. 데이터프레임 인덱싱 : matrix와 동일한 방법
## matrix에서도 가능한 것
df2[1, 2] ## 1행 2열에 위치한 값
df2[, 3]  ## 3열에 위치한 모든 값
df2[4,]   ## 4행에 위치한 모든 값
df2[, "btype"]  ## btype 열(3열)에 위치한 모든 값
df2[, c("name", 'age')] ## 추출하고 싶은 열이 여러 개인 경우
df2[, 1:3]  ## 슬라이싱

## 데이터프레임에서만 가능한거 : 리스트의 특별한 경우
df2$smoking
df2$age

### 3. 데이터프레임 요약 함수
head(iris)  ## 선수 6개 샘플 산출
tail(iris)  ## 후수 6개 샘플 산출

dim(iris)   ## (150, 5) 데이터프레임의 차원
nrow(iris)
ncol(iris)

str(iris)   ## 이걸 쓰면 굳이 head나 tail, dim을 사용할 필요가 없음.

unique(iris[5]) ## 5열 품종의 유니크 값 파악. 문자열로 저장되어 있을 경우 유용
table(iris["Species"]) ## 각 유니크 값 별로 몇 개의 샘플이 있는지.

colMeans(iris)  ## 안됨. 모두 수치형만 있어야 함.
colMeans(iris[-5])
colMeans(iris[, -5])
colSums(iris[-5])

rowMeans(iris[, -5])  ## -> 자주는 안씀 ㅇㅇ
rowSums(iris[, -5])