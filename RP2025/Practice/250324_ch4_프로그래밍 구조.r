### Date : 2025-03-24
### Author : Hollyriver
### Title : 4. Programming Architecture

##----------2. Conditional Statement----------
### 1. if문
## ex) 시험 점수가 80점 이상이면 합격 출력
score <- 85

if (score >= 80) {
  print("Pass")
}

## 실행하고 싶은 게 한 줄이면...
if (score >= 80) print("Pass")

### 2. if-else문
score <- 75

if (score >= 80) {
  print("Pass")
} else {
  print("Fail")
}

if (score >= 80) print("Pass") else print("Fail") ## 이런건 되네

## 들여쓰기 개판으로 해놔도 돌아감
if (score >= 80) {
    print("Pass")
      } else {
  print("Fail")
}

### 3. ifelse() 함수
score <- 85
result <- ifelse(score >= 80, "Pass", "Fail") ## ifelse(bool, arg_T, arg_F)
print(result)

### 4. else if문
score <- 85

if (score >= 90) {
  grade <- "A"
} else if (score >= 80) {
  grade <- "B"
} else if (score >= 70) {
  grade <- "C"
} else if (score >= 60) {
  grade <- "D"
} else {
  grade <- "F"
}

print(grade)

##----------3. Reputative Statement----------
### 1. for 문
#### *을 5번 출력
for (반복변수 in 1:5) {
  print("*")
}

#### 구구단 2단을 출력
for (i in 1:9) {
  print(cat("2 ×", i, "=", 2*i))  ## 이렇게 쓰니까 뒤에 NULL이 붙음;;
}

output <- ""

for (i in 1:9) {
  output <- cat(output, "2 ×", i, "=", 2*i, "\n")
}

## 이것도 안되네. 개오바. 그냥 cat은 프린트만 해주는 거인듯


#### 1~20 사이의 숫자 중 짝수만 출력
for (i in 1:20) {
  if (i %% 2 == 0) {
    print(i)
  }
}

#### 1~n번째 원소까지의 합을 계산 -> 등차수열의 합
sum <- 0
n <- 100

for (i in 1:n) {
  sum <- sum + i
}

print(sum)  ## 등차수열 합공식 뭐더라

### 2. while 문
#### 1~100 사이의 숫자를 합계 출력
sum <- 0
i <- 1

while (i <= 100) {
  sum <- sum + i
  i <- i + 1
}

print(sum)

#### 무한루프 : 하면 안됨

### 3. break문과 next문
## 1부터 100까지 더하기 : while문 버전
sum <- 0
i <- 1

while (TRUE) {
  sum <- sum + i
  i <- i + 1
  
  if (i > 100) {
    break
  }
}

## 1~10 사이의 숫자 중에서 홀수의 합계
sum <- 0

for (i in 1:10) {
  if (i%%2 == 0) {
    next
  }
  sum <- sum + i
}

## └ 실습을 위한 것일뿐, 매우 효용성 없는 코드임. 그냥 네, 뭐.