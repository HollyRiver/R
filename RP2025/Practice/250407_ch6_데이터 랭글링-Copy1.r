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



##----------포매팅----------##
library(tidyverse)

# wide to long - table4a
table4a

table4a %>%
  pivot_longer(c(`1999`, `2000`), ## cols arg는 select문과 동일하게 사용
               names_to = "year", values_to = "cases") %>%
  mutate(year = parse_integer(year)) ## 그냥 as.numeric하면 안되나...?


# wide to long 2 - table4b
table4b

table4b %>%
  pivot_longer(c(`1999`, `2000`),
               names_to = "year", values_to = "population") %>%
  mutate(year = parse_integer(year))


# wide to long 3 : 실습
relig_income

relig_income %>%
  pivot_longer(contains("k"), names_to = "incomes", values_to = "count")

## select 문법 : 마이너스 부호를 사용하여 제거할 수 있음
relig_income %>%
  pivot_longer(-religion, names_to = "incomes", values_to = "count")

#----------------------------------#

billboard %>% colnames

billboard %>%
  pivot_longer(starts_with("wk"), names_to = "week", values_to = "rank")


billboard %>%
  pivot_longer(starts_with("wk"),
               names_to = "week", values_to = "rank",
               names_prefix = "wk", ## 접두사 제거
               values_drop_na = TRUE ## 결측값 제거
               )


# long to wide 1
table2

table2 %>%
  pivot_wider(names_from = type,
              values_from = count) ## 없앨 column

?pivot_wider


## 인구 10만명 당 평균 결핵 건수
table2 %>%
  pivot_wider(names_from = type,
              values_from = count) %>%
  mutate(cpp = cases / population * 1e5)


## year를 기준으론 long format이므로, 더 늘림
table2 %>%
  pivot_wider(names_from = type,
              values_from = count) %>%
  mutate(cpp = cases / population * 1e5) %>%
  ## year에 대한 wide format
  pivot_wider(names_from = year,
              values_from = c(cases, population, cpp)) %>%
  View


table2 %>%
  pivot_wider(names_from = type,
              values_from = count) %>%
  mutate(cpp = cases / population * 1e5) %>%
  pivot_wider(names_from = year,
              values_from = c(cases, population, cpp)) %>%
  relocate(country, contains("1999")) %>% ## 연도별로 정렬하고 싶음
  View

## 한번에도 됨
table2 %>%
  pivot_wider(names_from = c(type, year),
              values_from = count)


# long to wide 2
fish_encounters
fish_encounters$seen %>% unique() ## 1

fish_encounters %>%
  pivot_wider(names_from = station, values_from = seen) ## 매칭되지 않는 값은 자동 NA

## 물고기를 봤냐/못봤냐니까 1과 0으로 바꾸고 싶음 : NA -> 0
fish_encounters %>%
  pivot_wider(names_from = station,
              values_from = seen, values_fill = 0)



##----------열의 분리 및 결합-----------##

# 분리
table3

table3 %>%
  separate(rate, into = c("cases", "population"), sep = "/") %>%
  mutate(cases = parse_integer(cases),
         population = parse_integer(population))


# 결합
table5 %>%
  unite(col = year, century, year, sep = "") %>%
  mutate(year = parse_integer(year))



##----------결측값의 처리----------##
# 전염성 contagious
x <- c(1,2,3, NA)
sum(x, na.rm = TRUE)

NA + 10 ## 전염성
10 == NA ## 산술 연산자가 아닌 비교연산자도 동일

a <- NA
is.na(a)


# 명시적/암묵적 결측값

## 2015년 4분기 수익은 NA로 표시되어 있으므로, 명시적 결측값임
## 2016년 1분기 수익은 데이터셋이 존재하지 않으므로, 암묵적 결측값임
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66))

stocks %>%
  pivot_wider(names_from = year,                      # year를 열로 pivot하여 명시적으로 만듦
              values_from = return) %>%
  pivot_longer(cols = c(`2015`, `2016`),              # 명시적 결측값이 중요하지 않다면
               names_to = "year",                     # 암묵적으로 만듬(NA 제거)
               values_to = "return",
               values_drop_na = TRUE) ## 결측값 제거

## 결측값 명시화
stocks %>%
  pivot_wider(names_from = year, values_from = return) %>%
  pivot_longer(c(`2015`, `2016`), names_to = "year", values_to = "return") %>%
  relocate(year, qtr) %>%
  arrange(year, qtr)



## 결측값 처리 함수

### 명시적 결측값 생성 - complete()
stocks %>%
  complete(year, qtr) ## 원래 포맷을 유지시켜준다는 점에서 간결



### 결측값이 포함된 행 제거 - drop_na()
mytbl <- tibble(x = c(1, 2, NA), y = c("a", NA, "b"))
mytbl %>% drop_na ## 행에 대하여 결측값이 하나라도 있으면 제거

mytbl %>% drop_na(x) ## x 열에 대해서 결측값이 있는 행 제거


### 결측값을 사용자가 지정한 값으로 대체 - replace_na()
mytbl %>%
  replace_na(list(x = 0, y = "unknown")) ## 딕셔너리로 명시

mytbl %>%
  replace_na(list(x = 0)) ## 단일 값도 그냥 이렇게...

mytbl %>%
  mutate(x = replace_na(x, 0))


### 이월된 값으로 NA 대체 - fill
### 값을 하나만 사용해서 넓게 묶는 상황으로 사용함
tibble(person = c("Derrick Whitmore", NA, NA, "Katherine Burke"),
       treatment = c(1, 2, , 1), response = c(7, 10, 9, 4)) %>% 
  fill(person) ## 데릭으로 NA가 전부 채워짐


#----------4. stringr----------#
library(tidyverse)
setwd("C:/Users/default.DESKTOP-VHFHFGU/Downloads")



##---------A. 문자열 기초----------##
str = c("a", "R for data science", NA)
str_length(str) ## 벡터 기반으로 함수 적용

str_mat = matrix(as.character(1:10), 5, 2)
str_length(str_mat) ## 행렬도 됨

str_length(123) ## 문자열 아닌것도 됨

###----------str_length()----------###

## 미국의 아기 이름들(적어도 5명 이상 쓰는 경우)
install.packages("babynames")
library(babynames)

babynames

### 이름 길이의 분포 파악 - 해당 이름을 가진 인구수 기준
babynames %>%
  mutate(name_length = str_length(name), .after = name) %>%
  count(name_length, wt = n)


babynames %>%
  count(name_length = str_length(name), wt = n) ## 아예 열을 만들어서 넣을 수 있음

### 이름 길이가 15인 이름 추출 + 몇명이 해당 이름을 가지는지
babynames %>%
  filter(str_length(name) == 15) %>% ## str_length(name)은 n으로 생성됨
  count(name, wt = n)


### str_length(col) 자체는 열처럼 바로 쓸 수 있음


###----------str_sub----------###
### sub string
### 1번째 문자부터 3번째 문자까지 추출
x <- c("Apple", "Banana", "Pear")

str_sub(x, 1, 3) ## x의 1번째 문자부터 3번째 문자까지 추출

str_sub(x, -3, -1) ## 끝에서 3번째 문자부터 마지막 문자까지 추출 - 파이썬 인덱싱?


### 첫 번째 / 마지막 문자 추출
babynames %>%
  mutate(first = str_sub(name, 1, 1),
         last = str_sub(name, -1, -1))


###----------lower/upper----------###
### 대소문자 변환
str_to_lower(c("Apple", "Banana", "Pear"))
str_to_upper(c("Apple", "Banana", "Pear"))


##----------B. 데이터에서 문자열 생성----------##

###----------str_c----------##
### combine string
letters
LETTERS

str_c("Letter: ", letters)
str_c("Letter: ", LETTERS)

str_c("Letter", letters, sep = ": ") ## 구분자 생성

str_c(letters[-26], " comes before ", letters[-1])

### 벡터를 단일 문자열로 결합
str_c(letters, collapse = "")
str_c(letters, collapse = ", ")


### 결측값이 있는 경우
x <- c("a", NA, "b")
str_c(x, "-d") ## NA의 전염성


### str_replace_na(NA) : 결측값을 "NA" 그대로 출력
str_c(str_replace_na(x), "-d")


### 테이블에서의 사용
info <- tibble(name = c("Kim", "Lee", "Park"))
info %>%
  mutate(greeting = str_c("Hi, ", name, "!"))


###----------str_glue----------##
### 그냥 f-string임
name <- "Park"

str_c("Hello, ", name, "!")
str_glue("Hello, {name}!")
str_glue("2 + 3 = {2 + 3}")
str_glue("Today is {str_to_upper('monday')}") ## 내부는 다른 따옴표로...
str_glue('Today is {str_to_upper("monday")}')

str_glue("asdf \{\}") ## 근데 이런건 안됨...



## Date : 2025-05-12
## Author : 강신성
## Student code : 202014107
## Title : 데이터 랭글링

#----------4. stringr----------
library(tidyverse)
setwd("C:/Users/default.DESKTOP-VHFHFGU/Downloads")



##------------str_glue()--------------##
name = "Kim"
str_glue("Hello, {name}!\nWelcome to the team")

## 줄바꿈이나 탭도 개행문자 없이 반영됨
str_glue("Hello,  {name}!
         Welcome to the team")


## 결측값 개별 처리 가능
name <- c("Kim", NA, "Park")
str_glue("HI, {name}", .na = "Friend") ## NA를 문자열로 대체

str_glue("Hi, {replace_na(name, 'Friend')}")


## str_glue_data() : 데이터프레임 처리 전용
info <- tibble(name = c("Kim", "Lee", "Park"),
               age = c(25, 30, 42),
               city = c("Seoul", "Jeonbuk", "Gwangju"))

### 각 행별로 적용
info %>% str_glue_data("{name} is {age} years old and lives in {city}.")


### 결측값 처리
info2 <- tibble(name = c("Kim", NA, "Park"),
               age = c(25, 30, NA),
               city = c("Seoul", "Jeonbuk", "Gwangju"))
#info2 <- info
#info2[2, 1] <- NA

info2 %>% str_glue_data("{name} lives in {city}.", .na = "Unknown")


### mutate와 결합하여 새로운 열 생성
info %>%
  mutate(message = str_glue_data(info,
                                 "{name} ({age} year old) lives in {city}."))


##----------str_flatten()----------
str_flatten(c("x", "y", "z"), collapse = ", ")
str_c(c("x", "y", "z"), collapse = ", ") ## 똑같음

### 마지막 원소는 다르게 결합
str_flatten(c("x", "y", "z"), collapse = ", ", last = ", and ")
str_c(c("x", "y", "z"), collapse = ", ", last = ", and ") ## 얜 안됨


### 하나의 셀에 여러 개의 데이터가 들어가도록............
mytbl <- tibble(name = c("Carmen", "Carmen", "Marvin", "Terence", "Terence", "Terence"),
                fruit = c("banana", "apple", "nectarine", "cantaloupe", "papaya", "madarine"))

mytbl %>%
  group_by(name) %>%
  summarise(fruits = str_flatten(fruit, ", "))



##-----------정규 표현식 / str_view-------------
### 기초 매칭 : .
x <- c("apple", "banana", "pear")

str_view(x, "a") ## 일치하는 문자 표시
str_view(x, ".a.") ## 앞뒤에 아무 문자나 존재, 중복으로 매칭 불가

str_view("aa \na \ta", ".a") ## 줄바꿈만 안되고, 탭은 됨


### 앵커 : ^ - 맨 처음, $ - 맨 끝
str_view(x, "^a") ## 약간 문자열 자체가 "^ ... $"로 만들어졌다고 생각하면 편함
str_view(x, "a$")

str_view("aba", "^a$")
str_view("a", "^a$")
str_view("", "^$") ## 문자열이 "^ ... $"로 이뤄져 있으니까... "^$"만 들어가있으면 빈거


### 반복
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"

str_view(x, "CC?") ## C 또는 CC를 찾음
str_view(x, "C?") ## 이렇게만 쓰면 앞에 있는 C가 0번이니까... 그냥 다 호출
str_view(x, "C*") ## 이것도 앞에 있는 C가 0번 이상 있는거니까... 다 호출

str_view(x, "CC+") ## CC, CCC, CCCC ...
str_view(x, "CC*") ## C, CC, CCC, CCCC ...

#### n회 반복하도록
str_view(x, "C{2}") ## 2번만 반복하는 경우 탐색
str_view(x, "C{2,}") ## 2번 이상 반복
str_view(x, "C{2,5}") ## 2번 이상, 5번 이하 반복


### 실제 사용 예시
x <- c("color", "colour")
str_view(x, "colou?r") ## u가 없거나 한 번 있거나 -> color or colour


### 그룹화
x <- c("gray", "grey")
str_view(x, "gr(a|e)y")

x <- c("summarize", "summarise")
str_view(x, "summari(z|s)e")

x <- c("mamama", "mamasdf")
str_view(x, "(ma){3}")


### escape 문자열 : \
writeLines("a\\b") ## \를 쓰기 위해 escape 문자열을 사용
str_view("a\\b", "\\\\") ## \\\\ -> "\\" -> \ (output)

str_view(c("abc", "a.c", "bef"), "a.c") ## 정규 표현식으로 먹힘
str_view(c("abc", "a.c", "bef"), "a\\.c") ## \\. -> "\." -> .


### character class
names <- c("Hadley", "Mine", "Garrett")

#### 모음이 있는 것
str_view(names, "[aeiou]")
str_view(names, "a|e|i|o|u") ## 일단 이거랑 똑같긴 함


#### 자음이 있는 것
str_view(names, "[^aeiou]") ## []안에 있는 것 제외하고 일치


#### 자음이 연달아 있는 것
str_view(names, "[^aeiou]+") ## 하나 이상

#### 이건 뭐임? 애매함
str_view(names, "[^aeiou]*") ## 자음이 0개 이상...
str_view(names, "[^aeiou]?") ## 자음이 0개 또는 1개 이상


#### 자주 사용되는 문자 클래스
text <- "The total cost is  29 dollars\nand 99 cents."

writeLines(text)

str_view(text, "\\d") ## \\d -> "\d" : 숫자
str_view(text, "\\s") ## \\s -> "\s" : 여백 문자(공백, 줄바꿈, 탭)



##----------정규 표현식을 활용한 문자열 패턴 매칭-----------
### str_detect() : 문자열에 특정 패턴이 존재하는지 확인
x <- c("apple", "banana", "pear")

str_detect(x, "e$")


### words data
words

#### "t"로 시작하는 단어 개수
str_detect(words, "^t") %>% sum()

#### "t"로 시작하는 단어 추출
words[str_detect(words, "^t")] ## 어우야 복잡하다


### str_subset() : 패턴이 일치하는 문자열 벡터를 반환
str_subset(words, "^t")


#### 모음으로 끝나는 단어의 비율
mean(str_detect(words, "(a|e|i|o|u)$"))
mean(str_detect(words, "[aeiou]$"))



library(babynames)


#### "x"로 끝나는 이름...?
babynames %>%
  filter(str_detect(name, "x$")) ## 필터링 / 열을 점검


#### 연도별로 "x"로 끝나는 고유한 이름의 비율
babynames %>%
  group_by(year) %>%
  summarize(
    rate = mean(str_detect(name, "x$"))
  )


### str_count() : 문자열별로 패턴이 일치하는 경우가 몇 번 있는지 벡터로 반환
x <- c("apple", "banana", "pear")
str_count(x, "p")


#### 이름에서 자음의 개수와 모음의 개수 출력
babynames %>%
  count(name) %>%
  mutate(vowels = str_count(name, "[AEIOUaeiou]"),
         consonants = str_count(name, "[^AEIOUaeiou]"))

####### 대소문자 자세히 봐야 함! ########


## Date : 2025-05-14
## Author : 강신성
## Student code : 202014107
## Title : 데이터 랭글링

#---------------------------------------#
library(tidyverse)
setwd("C:/Users/default.DESKTOP-VHFHFGU/Downloads")


##----------str_extract()----------
sentences ## 720개의 문장 제공

colors <- c("red", "orange", "yellow", "green", "blue", "purple") # ^red$로 하는 게 아니라, " red"이렇게 해야 하는 거 아닌가...

### 문자열 벡터에서 하나의 정규 표현식으로 변환
str_c(colors, collapse = "|")
str_flatten(colors, "|")

color_match <- str_flatten(colors, "|")


### 색상 문자열을 포함하는 문장 - 원소를 통째로 추출
has_color <- str_subset(sentences, color_match)


### 처음 일치하는 텍스트만 추출
str_extract(has_color, color_match) ## 없으면 NA

more <- sentences[str_count(sentences, color_match) > 0]
str_view(more, color_match)
str_extract(more, color_match)

### 일치하는 텍스트 여러 개 반환
str_extract_all(more, color_match) ## 리스트로 반환
str_extract_all(has_color, color_match, simplify = TRUE)


##-------------str_replace()-------------
### 일치하는 문자열 변환
x <- c("apple", "banana", "pear")
str_replace(x, "[aeiou]", "-") ## 처음 하나만 변환
str_replace_all(x, "[^aeiou]", "-") ## 전부 변환 - 이쪽이 더 유용할듯


### 벡터를 이용해서 여러 패턴을 한번에 변경 가능
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))



##------------str_split()---------------
### 파이썬의 "txt".split()처럼 쓰면 됨
sentences %>% head(5) %>%
  str_split(" ")


### 행렬 형태로 반환
sentences %>% head(5) %>%
  str_split(" ", simplify = TRUE)


### 대체 불가능할듯 왠만해선
x <- "This is a sentence. This is another sentence."
str_view(x, boundary("word")) ## 단어 인식 -> " "
str_view(x, boundary("sentence")) ## 문장 인식 -> "\\."?
str_view(x, boundary("line_break")) ## 형태소? 어간?이었나
str_view(x, boundary("character")) ## 글자 인식

?boundary()


#------------------forcats------------------#
gss_cat


##-----------levels reorder----------
fct1 <- factor(c("b", "b", "a", "c", "c", "c"))
fct1 ## 기본적으로 사전순으로 나옴


### levels를 처음 나타나는 순서대로 - 입력순으로 재정렬
fct_inorder(fct1) ## in order


### 각 수준의 빈도가 큰 순서대로 재정렬
table(fct1) ## c, b, a

fct_infreq(fct1) ## in frequency


### 레벨 자체를 수치값으로 나타낼 수 있을 때, 그 순서대로 정렬(ASC)
fct2 <- factor(1:3, levels = c("2", "3", "1"))
fct2

tmp <- factor(1:3, levels = c(2, 3, 1)) ## 이렇게 하면 안되나...?
levels(tmp) ## 문자열로 먹음


fct_inseq(fct2)
fct_inseq(tmp)


### 레벨을 뒤바꿈
levels(fct1)
fct_rev(fct1)
fct_rev(fct2)



## gss_cat 예제
### 결혼 상태에서 수준은 각 수준의 빈도에 오름차순 재정렬
gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) + geom_bar()


## Date : 2025-05-19
## Author : 강신성
## Student code : 202014107
## Title : 데이터 랭글링

#----------forcats----------#
library(tidyverse)

## fct_reorder : 특정 변수를 기준으로 팩터 수준을 재정렬 - .desc
summary1 <- gss_cat %>%
  group_by(marital) %>%
  summarise(tvhours = mean(tvhours, na.rm = TRUE),
            n = n()) %>% # .$marital %>% levels
  mutate(marital = fct_reorder(marital, tvhours)) # %>% .$marital %>% levels

summary1$marital %>% levels
gss_cat$marital %>% levels


### 그래프를 통한 확인 - ASC로 정렬되었음을 알 수 있음
library(ggplot2)
ggplot(summary1, aes(tvhours, marital)) +
  geom_point(size = 3) +
  theme(axis.title = element_text(size = 15),
        axis.text = element_text(size = 15))



## fct_relevel : 지정한 수준을 앞쪽(처음)으로 이동하여 재정렬
### 소득에 따른 평균 연령
gss_cat %>% count(rincome) ## rincome별 빈도수

summary2 <- gss_cat %>%
  group_by(rincome) %>%
  summarize(age = mean(age, na.rm = TRUE),
            n = n())

#### 소득구간 자체가 순서형 자료이기 때문에 연령별로 reorder하면 틀림...
ggplot(summary2, aes(x = rincome, y = age)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme(axis.text = element_text(size = 15))

### Not applicable도 아래(맨 처음)로 옮기고 싶다...
ggplot(summary2, aes(x = fct_relevel(rincome, "Not applicable"), y = age)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme(axis.text = element_text(size = 15))


##------------3. 팩터 수준 levels 변경-------------
gss_cat %>% count(partyid) ## 민주당 / 공화당


## fct_recode() : 일일히 변경, 명시적으로 언급되지 않은 수준은 유지
### 기존 팩터 이름만 변경... 명시하지 않은 레벨은 그대로...
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat")) %>%
  count(partyid)


### 몇개를 병합... (나머지를 Other로 통합)
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party")) %>%
  count(partyid)


## fct_collapse : 여러 수준을 한번에 병합 가능, 명시하지 않은 레벨은 그대로, 문자열이 아닌 변수처럼 입력
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat"))) %>%
  count(partyid)


## fct_lump : 상대적으로 빈도가 낮은 수준을 묶어 "Other"로 병합
gss_cat %>% count(relig, sort = TRUE)

### 빈도가 가장 높은 상위 10개의 종교만 남김
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) ## 기존에 Other가 이미 있어서 10개만


### Other 대신 다른 표현으로
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10, other_level = "Others...")) %>%
  count(relig, sort = TRUE) ## 11개 나옴


### 점유율이 0.05 미만인 종교만 남김
gss_cat %>%
  mutate(relig = fct_lump(relig, prop = 0.05)) %>%
  count(relig, sort = TRUE)




#----------lubridate----------#
# library(lubridate) ## 안해도 되는 걸 보니, 구버전 오류인가봄
today()
now()


##----------문자열로부터 생성 - 그냥 dmy 세 문자 조합 다됨-----------
### 연-월-일
dt <- ymd("2017-01-31")
class(dt)

### 월-일-년
dt2 <- mdy("January 31st, 2017")
class(dt2)

### 일-월-년
dt3 <- dmy("31-Jan-2017")
class(dt3)


## 시각을 넣을 경우에도 dmy 세 문자 조합 다됨...
### 시:분:초까지
dttm1 <- ymd_hms("2017-01-31 20:11:59")
class(dttm1) ## POSIXct / POSIXt - KST 이런건가

### 시:분까지
dmy_hm("31/01/2017 08:11")


##--------------make_datetime : 티블에서 <dttm> 시간 추출하기--------
library(nycflights13)
flights %>% glimpse()


### 굳이굳이 str_glue 활용
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = str_glue("{year}-{month}-{day}")) %>%
  mutate(departure = ymd(departure))

### 간단히...
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute))


### hour와 minute를 각각 분리하여 추출한 후, date-time 생성
time <- 815
time %/% 100

make_datetime_100 <- function(year, month, day, time) {
  return(make_datetime(year, month, day, time %/% 100, time %% 100))
}

flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>% ## 결측치 제거
  mutate(dep_time = make_datetime_100(year, month, day, dep_time),
         arr_time = make_datetime_100(year, month, day, arr_time),
         sched_dep_time  = make_datetime_100(year, month, day, sched_dep_time),
         sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
         )

flights_dt


## as_datetime / as_date : 상호 전환(정보 손실 발생)
as_datetime(today())
as_date(now())




##----------날짜/시간 유형 확인-----------
td <- "2025-05-19 17:32:55"
year(td)
month(td, label = TRUE)
month(td, label = TRUE, abbr = FALSE)

day(td)
hour(td)
minute(td)
second(td)

yday(td)
mday(td) ## 사실상 day(td)임
wday(td)
wday(td, label = TRUE)
wday(td, label = TRUE, abbr = FALSE)


wday("2001-02-27 01:00:00", label = TRUE, abbr = FALSE)



##----------시간 범위----------
## duration
dday = today() - ymd(20250302)
as.duration(dday) ## 78일을 초단위로 변환


### 특정 단위를 duration으로 변환
dseconds(15)
dminutes(10)
dhours(c(12, 24))
ddays(0:5)
dweeks(3)
dmonths(1:6)
dyears(1)


### 산술연산
dyears(0.5) + dweeks(12) + dhours(15)
dyears(0.5) - ddays(182)
2*dyears(1)
tomorrow <- today() + ddays(1) ## duration을 더하면 dttm이 됨
tomorrow

last_year <- today() - dyears(1)
now() - dyears(1) ## 1년을 뺐을 때, 정확히 지금이 안나옴 : 생각한 거랑 조금 다르게 나올 수 있음


### 일광 절약 시간제
one_pm <- ymd_hms("2025-03-08 13:00:00", tz = "America/New_York") ## time zome?
one_pm ## EST
one_pm + ddays(1) ## 하루만 더했는데 1시간 더 증가



## Date : 2025-05-21

##----------------period--------------------
## period - duration이 초단위로 나타나는 것과 달리 ymdhms로 표시됨
### period 생성 : duration에서 d만 빼면 됨 <- 거꾸로 기억하는 게 나을 듯
seconds(15)
minutes(10)
hours(c(12, 24))
days(0:5)
weeks(3)
months(1:6)
years(1)


### 덧셈, 뺄셈, 곱셈 연산
10 * (months(6) + days(1))
days(50) + hours(25) + minutes(2)


### 윤년
ymd("2024-01-01") + dyears(1) ## 2024-12-31
ymd("2024-01-01") + years(1)  ## 2025-01-01


### 일광 절약 시간제
one_pm <- ymd_hms("2025-03-08 13:00:00", tz = "America/New_York")
one_pm                                  # "2025-03-08 13:00:00 EST"
one_pm + days(1)                        # "2025-03-09 13:00:00 EDT" -> 유동적으로 23시간을 더함



## 예정된 도착 일시, 실제 출발 일시, 실제 도착 일시를 date-time 형식으로 생성
## → sched_arr_time, dep_time, arr_time은 HHMM 또는 HMM 형식으로 되어 있어,
##   시(hour)와 분(minute)을 각각 분리하여 추출해야 함
library(nycflights13)

### 주어진 열들을 이용하여 dttm을 만드는 함수
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

### 각 시간들을 dttm 형식으로 변환
flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(dep_time = make_datetime_100(year, month, day, dep_time),
         arr_time = make_datetime_100(year, month, day, arr_time),
         sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
         sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt %>%
  select(dep_time, arr_time) %>%
  filter(arr_time < dep_time) ## 있으면 안될 것이 있음 -> 아님

### 출발일만 지정되어 있을 뿐 도착일은 따로 없기 때문에 문제가 발생함
### 다음날에 도착한 항공편(심야 항공편)의 도착 일시에는 하루를 더해줘야 함
flights_dt %>%
  mutate(overnight = arr_time < dep_time) %>%
  select(dep_time, arr_time, overnight)


flights_dt %>%
  mutate(overnight = arr_time < dep_time,
         arr_time = arr_time + days(overnight*1)) %>% ## 하루를 더해줌
  select(dep_time, arr_time) %>%
  filter(arr_time < dep_time)



##----------------interval--------------------
## interval 생성
library(lubridate)
next_year = today() + years(1)
interval(today(), next_year)

## interval 기간
years(1) / days(1) ## 소수점이 나옴 365.25
dyears(1) / ddays(1)


(today() %--% next_year) / ddays(1)                   # 365
(ymd("2024-01-01") %--% ymd("2025-01-01")) / ddays(1) # 366(윤년)