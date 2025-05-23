## Date : 2025-03-31
## Author : HollyRiver
## Title : tidyverse 통합 패키지

##----------1. 파이프 연산자----------
library(tidyverse)  ## magrittr이 있어야 파이프연산자가 동작

## 사용할 데이터
head(mtcars)

## magrittr 파이프 연산자 %>%
mtcars %>% head %>% lapply(summary)
mtcars %>% lm(mpg~disp, .)
mtcars %>% .$gear ## 굳이 이럴 필요는 없지만, 일단 됨

## R 기본 파이프 연산자 |>
mtcars |> lm(mpg~disp, data = _)
mtcars |> head(2)
mtcars |> _$gear

##----------2. tibble 패키지-----------
install.packages("nycflights13")
library(nycflights13)

flights

flights %>% View

## tibble 생성
mydf <- data.frame(
  x = 1:5,
  y = 1 ## 재사용 규칙, 하지만 배수는 지켜줘야...
)

mydf

## 데이터프레임 만들듯이 그냥 해버리면 됨
mytbl <- tibble(
  x = 1:5,
  y = 1
)

mytbl

## 새로운 열을 만들고 싶은데, 기존 열을 활용하고 싶음...
data.frame(
  x = 1:5,
  y = 1,
  z = x^2 + y
) ## 절대 안만들어짐. 되겠냐?

tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
) ## 이게 됨

## 변수 확장성
mytbl <- tibble(
  x = 1:5,
  y = 1,  # recycling rule
  z = x^2 + y,
  `1st` = 11:15,
  `2nd` = 21:25,
  `  1asdf$%#  *&( `= 31:35
)

mytbl

## 실제 테이블에 들어가는 가시적 순서대로 데이터를 입력할 수 있는 모듈도 존재 -> 안씀


## 상호 변환
iris %>% as_tibble
flights %>% as.data.frame


mytbl <- tibble(
  x = 1:5,
  y = 1,  # recycling rule
  z = x^2 + y,
)

mydf <- data.frame(mytbl)

class(mydf[, 1:2])  ## df
class(mydf[, 1])  ## vector

class(mytbl[, 1:2]) ## tbl
class(mytbl[, 1])   ## tbl. 동일한 자료구조를 가짐

mytbl[, 1]

## 이렇게 해야 벡터 추출이 가능
mytbl[[1]]
mytbl$x
mytbl[["x"]]