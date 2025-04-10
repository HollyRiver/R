## Date : 2025-04-07
## Author : 강신성
## Student code : 202014107
## Title : 데이터 랭글링

#----------1. readr 패키지-----------
library(tidyverse)
setwd("C:/Users/default.DESKTOP-VHFHFGU/Downloads") ## 세션에서 설정하면 이걸 쓰는듯
## RStudio를 아이콘으로 열면 작업공간이 디폴트로 변경
## 이전에 사용했던 R script 파일로 열면 기존 작업공간 유지

data = read_csv("C:/Users/default.DESKTOP-VHFHFGU/Downloads/StudentSurvey.csv")

read_csv("StudentSurvey.csv", skip = 5) ## n개의 열을 무시함
read_csv("StudentSurvey.csv", col_names = FALSE, na = "9999") ## 열 이름 X1~Xn


#----------2. dplyr 패키지-----------
## 행 관련 - flights 데이터셋
library(nycflights13)
flights  ## 마지막 열 : <dttm> -> date time

dim(flights) ## (336776, 19)

flights %>% head  ## tibble같은 경우에는 그냥 보는 게 많음
flights %>% str   ## .info() 느낌
flights %>% glimpse  ## dplyr 함수. 일견. str과 유사하나, 콘솔 크기에 맞춤

### filter()
#### 120분 이상 연착한 항공편 - arr_delay가 120분 이상인 샘플
flights %>% filter(arr_delay >= 120)

#### 1월 1일에 출발한 항공편 - month는 1, day는 1인 샘플
flights %>% filter((month == 1) & (day == 1)) ## 832개
flights %>% filter(month == 1, day == 1) ## 되도록 만들어짐

#### 3, 5, 8월에 출발한 항공편
flights %>% filter(month %in% c(3, 5, 8))

value = 3
value %in% c(3, 5, 8)


### 행 관련 - arrange()
#### 출발 시간 순으로 정렬
flights %>% arrange(year, month, day, dep_time) ## 그냥 여러 변수 넣어도 됨

#### 가장 출발 지연시간이 길었던 항공편 확인
flights %>% arrange(desc(dep_delay))

flights %>% arrange(desc(arr_delay))

#### 대략 정시에 출발한 항공편 중에서(|"실제 출발 시간" - "예정된 출발 시간"| <= 10분)
#### 도착 지연시간이 가장 길었던 항공편 확인
flights %>% arrange(dep_delay)  ## ??? 일찍 출발한 경우도 존재함

flights %>%
  filter(dep_delay >= -10 & dep_delay <= 10) %>%
  arrange(desc(arr_delay)) %>%
  .[1, ]

### 열 관련 - select() : 데이터베이스 생각하면 됨
flights %>% select(year, month, day)  ## 몇 개 변수만 선택

flights %>% glimpse  ## year행부터 day행까지 추출하려면?

flights %>% select(year:day)  ## 벡터 만들듯이

#### 특정 변수 제외 선택
flights %>% select(-year)
flights %>% select(-year, -day)
flights %>% select(-(year:day))

#### 추출 시 변수 이름 변경까지 됨
flights %>%
  select(dep.time = dep_time,
         arr_time = arr_time)


### select 도우미 함수
flights %>% select(starts_with("sched")) ## 변수 이름이 "sched"로 시작하는 경우
flights %>% select(ends_with("time"))    ## 변수 이름이 "time"으로 끝나는 경우

flights %>% select(contains("arr"))         ## 변수 이름에 "arr"이 포함되는 경우
## -> carrier라는 의도하지 않은 변수가 들어감
flights %>% select(contains("arr_"))



### 열 관련 - mutate -> 다음 시간에



### 열 관련 - rename : 특정 변수 이름 변경
flights %>% rename(dep.time = dep_time,
                   arr.time = arr_time) %>%
  glimpse  ## select와 동일한 사용법. 하지만 얘는 이름만 바꿔줌.

# dt %>% rename(cnt2025 = `2025count`) ## 이런 식으로 씀


### 열 관련 - relocate : 변수의 위치 변경
flights %>%
  filter(dep_delay <= 10 & dep_delay >= -10) %>%
  arrange(desc(arr_delay)) %>%
  relocate(arr_delay, .after = day) ## 앞에 day를 둠

flights %>%
  filter(dep_delay <= 10 & dep_delay >= -10) %>%
  arrange(desc(arr_delay)) %>%
  relocate(arr_delay, .before = day) ## 뒤에 day를 둠

flights %>% relocate(air_time, distance) ## 기본적으로 앞에 데려옴
flights %>% relocate(carrier:tailnum, .before = day)  ## 콜론 사용 문법은 공유

#----------mutate----------
library(tidyverse)
library(nycflights13)

## 출발 지연 시간 - 도착 지연 시간 : 예상 비행시간보다 더 걸린 시간 아닌가
flights %>% mutate(gain = dep_delay - arr_delay, .after = day) %>%
  arrange(gain)
## 파이프 연산자 연결한 상태에서 줄바꿈 시, 얘가 세미콜론을 무력화시켜주는 느낌으로 작용하는 듯

## 속도 = 거리 / 비행시간 = mph
flights %>% mutate(speed = distance / (air_time/60),
                   .before = 1) ## 1번째 행 앞에 넣어라 == 맨 앞에 넣어라

#----------mutate와 자주 쓰이는 함수----------
## 전부 SQL 기능에 포함되는듯
## row_number() : 비행기 순서대로 번호 부여
flights %>% mutate(flight_order = row_number(), .before = 1)

## min_rank() : 동순위 발생 시 minimum 값으로 일괄 매김
## dense_rank() : 동순위 발생 시 항상 연속된 값을 부여

?min_rank

x <- c(5, 1, 3, 2, 2, NA) ## 결측값은 결측값으로
row_number(x) ## 얘가 동순위 발생 시 가장 먼저 등장한 값을 우선순위 설정
min_rank(x)
dense_rank(x)
min_rank(desc(x))
dense_rank(desc(x))

## 출발 지연시간의 순위
flights %>%
  mutate(delay_rank = min_rank(dep_delay), .before = 1) %>% ## 동순위 발생 시 건너뜀
  mutate(delay_dense = dense_rank(dep_delay), .after = delay_rank)  ## 동순위 발생 시 연속된 값 부여

## na_if(col, val) : 특정 값을 NA로 반환
flights %>%
  filter(dep_delay %in% c(-1, 0, 1)) %>%
  relocate(dep_delay, .before = 1) %>%
  mutate(dep_delay_na = na_if(dep_delay, 0))

## coalesce() : 여러 열을 넣었을 때, 첫 번째로 NA가 아닌 값을 반환. 없다면 NA를 반환
x <- c(1, 2, NA, NA, 5)
y <- c(NA, NA, NA, 4, 5)
coalesce(x, y)

## 출발 지연 시간이 NA인 경우, 도착 지연 시간을 대신 사용하는 경우
flights %>%
  filter(is.na(dep_delay)) %>%
  mutate(first_non_NA = coalesce(dep_delay, arr_delay), .before = 1) %>%
  relocate(arr_delay, .before = 2) ## 둘다 NA인거 밖에 없네