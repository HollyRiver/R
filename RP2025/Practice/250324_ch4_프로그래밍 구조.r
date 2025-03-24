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