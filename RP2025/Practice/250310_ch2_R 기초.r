## 주석을 활용해보자.

## Date : 2025-03-10
## Author : HollyRiver <- 주석에 연락처를 남겨두면 좋음
## Description : R 스크립트 연습

##----------Chapter 2. R 기초----------

##--------2.1 산술연산--------

3+5 ## 덧셈
10-7  ## 뺄셈
2*5 ## 곱셈
13/4  ## 나눗셈
13%%4 ## 나머지. 파이썬은 %임
13%/%4  ## 몫. 파이썬은 //임
2^10  ## 제곱. 파이썬은 **임

##--------2.2 산술연산 함수--------
log(10) ## 자연로그
?log ## log computes logarithms, by default natural logarthms.
log10(10)
log(10, base = 10) ## 이렇게 쓰면 밑을 맘대로 설정할 수 있음
sqrt(25)  ## square root
abs(-20)  ## absolute
factorial(10) ## 그냥 factorial;;
sin(2*pi) ## 원주율 값은 알아서 저장되어 있음
exp(1)    ## 자연상수

##--------2.4 자료형---------
# 숫자형
100
1.23
-200

# 문자형
'Hello'
"World"

# 논리형
TRUE
T
FALSE
F

# 특수값
NULL ## 정의되지 않음
NA ## 결측값 missing value
NaN ## 수학적으로 정의가 불가능한 값
Inf ## 무한


##--------2.5 논리연산---------
2<5
2<=5
2>5
2>=5
2==5 ## eq
2!=5 ## neq
TRUE | FALSE
TRUE & FALSE

##--------2.7 변수--------
# 변수값 지정
var1 <- 10
20 -> var2
total <- var1 + var2
print(total)

# 변수값 변경
var1 <- "a"
total <- var1 + var2 ## error