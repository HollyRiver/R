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

#----------mutate 2----------#
library(tidyverse)
library(nycflights13)

## 비행시간이 3시간 이상이면 Long Flight, 미만이면 Short Flight
flights %>%
  mutate(flight_time = if_else(air_time >= 180,
                               "Long Flight", "Short Flight"),
         .before = 1) %>%
  relocate(air_time, .after = "flight_time")

## 비행거리 기준으로 그룹화
flights %>%
  mutate(distance_group = case_when(
    distance < 500 ~ "Short haul",
    distance < 1500 ~ "Medium haul", ## 되는 것 같은데??????
    distance >= 1500 ~ "Long haul"
  ), .before = 1) %>%
  relocate(distance, .after = "distance_group")

## 항공사 이름 변경
flights %>%
  mutate(carrier_name = recode(carrier,
                               "AA" = "American Airlines",
                               "DL" = "Delta Airlines"),
         .before = 1) %>%
  relocate(carrier, carrier_name)

## 다대다 변경
mbti <- tibble(mbti = c("ESTJ", "ISFJ", "INTP", "ESTP"))
mbti %>%
  mutate(group = recode(mbti,
                        "ESTP" = "E",
                        "ESTJ" = "E",
                        "ISFJ" = "I",
                        "INTP" = "I"))
## 일괄적으론 못바꾸나?


#----------집단 관련 함수----------
## summarize == summarise
flights %>%
  summarize(n = n(),
            n_dis = n_distinct(air_time), ## 정수형임
            mean = mean(air_time, na.rm = TRUE),
            sd = sd(air_time, na.rm = TRUE),
            `1st` = first(air_time),
            last_value = last(air_time, na_rm = TRUE)) ## 따로 있는듯

## group_by
flights %>%
  group_by(month) %>% ## 월별 그룹화
  summarize(
    count = n(),
    delay = mean(dep_delay, na.rm = TRUE),
  )

### 여러 개의 변수로 그룹화
flights %>%
  group_by(month, day) %>%
  summarize(n = n()) %>%
  print(n = 100)

### 항공사별 항공편 개수 -> 빈도표
flights %>%
  group_by(carrier) %>%
  summarize(n = n())

## 도우미 함수 count()
flights %>% count(carrier)

flights %>% count(flight) ## 항공편 번호 별 몇회? ㅇ?

### 합계값 산출 -> n() 대신에 특정 변수 합계 출력
flights %>% count(carrier, wt = air_time)


#----------관계형 데이터 RD-----------
## nycflights13 패키지에서 flights와 관련된 테이블
airlines ## 항공사 풀네임
airports ## 공항 위치 정보
planes   ## 여객기 정보
weather  ## NYC 공항의 시각 별 날씨 정보

flights$flight %>% unique %>% length ## 중복 있음;
dim(flights)

flights$origin ## 출발
flights$dest   ## 도착 -> 둘다 airports faa에 종속
flights$tailnum ## planes tailnum에 종속
flights$carrier ## airline carrier에 종속


## 기본키 확인
planes %>% count(tailnum) %>%
  filter(n > 1) ## tailnum을 기준으로 그룹화한 것을 카운트했을 때, 전부 고유함

flights %>% count(tailnum) %>%
  filter(n > 1) ## 유니크가 3873.

flights %>% count(flight) %>% filter(n > 1)
## -> 기본키가 명시적으로 정해져있지 않을 수 있음. 차원이 1이지 않을 수 있음

weather %>% count(year, month, day, hour, origin) %>%
  filter(n > 1)
## -> 얘도 잘 안됨
weather
unique(weather) ## 일단 유니크하긴 한듯? 관계형 데이터는 맞음


## 뮤테이팅 조인 Mutating join
x <- tibble(key = c(1, 2, 3),
            value_x = c("x1", "x2", "x3"))
y <- tibble(key = c(1, 2, 4),
            value_y = c("y1", "y2", "y3"))

### inner join
x %>% inner_join(y) ## 알아서 이름이 같으면 자연조인 해줌
x %>% inner_join(y, by = "key")

### left_join
x %>% left_join(y, by = "key")

### right_join
x %>% right_join(y, by = "key")

### outer join
x %>% full_join(y, by = "key")


### 실제 데이터에서 활용
flights2 <- flights %>% select(year, month, day, hour, origin,
                               dest, tailnum, carrier)

flights2 %>% left_join(weather, by = c("year", "month", "day", "hour", "origin"))
flights2 %>% left_join(weather) ## 알아서 열 이름 같으면 잘 찾아서 해줌

### flights2와 planes를 조인
flights2 %>% left_join(planes) ## year, tailnum으로 매핑. 근데 각 테이블의 year 의미가 다름
flights2 %>% left_join(planes, by = "tailnum")


### flights2와 airports를 조인
### 조인하려는 테이블의 키에 해당하는 변수 이름이 다를 경우
flights2 %>% left_join(airports, by = c("origin" = "faa")) %>% ## 연산자 사용
  glimpse


## 필터링 조인
### 가장 인기있는 상위 10개 도착지
flights %>% count(dest) %>% arrange(desc(n)) %>%
  head(10)

top_dest <- flights %>% count(dest, sort = TRUE) %>% head(10) ## ASC면 어캄?

### 전체 운행 데이터에서 상위 10개 도착지 중 한곳으로 운행한 항공편 필터링
flights %>% semi_join(top_dest) ## 키는 알아서 똑같은거(dest) : 141135

### 이외의 항공편 필터링
flights %>% anti_join(top_dest) ## 195621

nrow(flights) ==  141135 + 195621 ## ?? 다름 뭔가 조인에서 문제가 있나봄
dim(flights)


### 항공기 리스트에 매칭되지 않는 항공기 필터링
flights %>% anti_join(planes, by = "tailnum") %>% count(tailnum, sort = TRUE)


#---------- tidyr ----------
library(tidyverse)
library(nycflights13)

setwd("C:/Users/default.DESKTOP-VHFHFGU/Downloads")


## 한글 데이터 불러오기
mydata <- read_csv("mydata.csv",
                   locale = locale(encoding = "CP949"))


## tidyr 연습용 데이터 : WHO에서 발표한 3개 국가 결핵 사례 수
table1 ## 이것도 근데 사실 long format 아님? -> 상대적 개념인듯
table2 ## long format - 인구와 발병사례 수
table3 ## 한 셀에 두 개의 값이 들어간 느낌

## table1의 wide format
table4a ## cases 연도를 열로 늘려버린 wide format
table4b ## population

table5  ## 연도를 문자열로 앞 뒤 두자리씩 나눔. 왜???

table1 %>%
  mutate(rate = paste0(as.character(cases), "/", as.character(population))) %>% ## 파이썬이 좋긴해
  select(country, year, rate)