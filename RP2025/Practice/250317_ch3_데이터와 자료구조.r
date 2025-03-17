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
