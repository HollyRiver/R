## Date : 2025-05-26
## Author : 강신성
## Student code : 202014107
## Title : 데이터 시각화

#----------ggplot2----------#
setwd("C:/Users/default.DESKTOP-VHFHFGU/Downloads")

##----------A. 막대 그래프-----------
library(tidyverse)
diamonds

### EX1. cut : 컷 품질에 대한 막대그래프
#### 기본적인 막대그래프
ggplot(diamonds, aes(x = cut)) + geom_bar()

#### 색상 설정
ggplot(diamonds, aes(x = cut)) + geom_bar(fill = "orange")

#### 범주 별 색상 설정
ggplot(diamonds, aes(x = cut, fill = cut)) + geom_bar()


### EX2. 두 개의 범주형 변수 cut / clarity에 대한 막대그래프
#### 누적형 : 도수 차이를 반영
ggplot(diamonds, aes(x = cut, fill = clarity)) + geom_bar()

#### 누적형 세부 조정 : 피규어를 변수에 저장
p = ggplot(diamonds, aes(x = cut, fill = clarity))
p + geom_bar() ## 누적 막대 그래프 : stack
p + geom_bar(position = "fill") ## 각 범주의 도수를 1로 하여 상대도수 표시

#### 두 개 범주를 각각 그림
p + geom_bar(position = "dodge")
p + geom_bar(position = "identity") ## 약간 너무 적은건 빼는 느낌 같은데



### EX3. 데이터 자체가 요약된 통계량일 경우
mytbl <- tibble(group = factor(c("A", "B", "C")),
                freq = c(20, 15, 30))
mytbl

#### 막대그래프
ggplot(mytbl, aes(x = group)) + geom_bar() ## 관측된 열이 한개씩밖에 없음...
ggplot(mytbl, aes(x = group, y = freq)) +
  geom_bar(stat = "identity") ## 집계하지 않고 넣어준 값 자체를 stat으로 사용

diamonds %>% count(cut) %>%
  ggplot(aes(x = cut, y = n, fill = cut)) +
  geom_bar(stat = "identity")


### EX4. 가로형 막대그래프
ggplot(mytbl, aes(x = freq, y = group)) + geom_bar(stat = "identity")
ggplot(diamonds, aes(y = cut, fill = cut)) + geom_bar()



### EX5. 인종의 빈도가 큰 순서대로 시각화
gss_cat$race %>% levels ## 네 개 범주, Not applicable은 자료 없음
gss_cat %>%
  mutate(race = fct_infreq(race)) %>%
  ggplot(aes(x = race, fill = race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE) + ## 데이터 없는 범주 표시(이산형 x축)
  scale_fill_manual(values = c("darkorange", "steelblue", "#66a182", "#d1495b")) + ## 색상 변경
  labs(x = "", y = "Frequency") + ## axis label 변경
  theme(axis.title.y = element_text(size = 15, margin = margin(r = 10)), ## axis title text 속성
        axis.text = element_text(size = 15), ## x축과 y축 틱 텍스트 크기 설정
        legend.position = "none" ## 이미 아래에 있는데 쓰기 싫음
        )



### EX6. 항공편 출발 요일의 분포 시각화
library(lubridate)
library(nycflights13)


#### 예정된 도착 일시, 실제 출발 일시, 실제 도착 일시를 date-time 형식으로 생성
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

#### 결측치 처리 및 dttm으로 변경 후 필요한 데이터만 추출
flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(dep_time = make_datetime_100(year, month, day, dep_time),
         arr_time = make_datetime_100(year, month, day, arr_time),
         sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
         sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

#### 시각화
library(RColorBrewer) ## 팔레트 불러오기
flights_dt %>%
  mutate(wday = wday(dep_time, label = TRUE)) %>% ## 요일 변수 설정, 문자형으로(label = TRUE)
  ggplot(aes(x = wday, fill = wday)) + ## 범주별 색상
  geom_bar() +
  scale_fill_manual(values = brewer.pal(7, "Spectral")) + ## 필요한 색상(범주)의 개수 입력 무조건
  labs(x = "", y = "Frequency") + # axis.title.x 문자 없앰
  theme(axis.title.y = element_text(size = 15, margin = margin(r=10)),
        axis.text.x = element_text(size = 12),
        legend.position = "none") ## 범례 없앰


gss_cat$race %>% levels
gss_cat %>%
  mutate(race = fct_infreq(race)) %>%
  ggplot(aes(x = race, fill = race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE) +
  scale_fill_manual(values = brewer.pal(4, "Spectral")) + ## 4개 범주로 압축해서 재구성
  labs(x = "", y = "Frequency") +
  theme(axis.title.y = element_text(size = 15, margin = margin(r = 10)),
        axis.text = element_text(size = 15),
        legend.position = "none"
  )



##----------B. 히스토그램----------
PlantGrowth ## 처리에 따른 식물의 건조중량

### EX1. 기본 히스토그램 : 범주 구분하지 않음
ggplot(PlantGrowth, aes(x = weight)) + geom_histogram()
ggplot(PlantGrowth, aes(x = weight)) +
  geom_histogram(fill = "steelblue", color = "gray", bins = 10) + ## bins 조정 color는 테두리임
  labs(title = "식물의 건조중량 히스토그램", ## 기본적으로 왼쪽 정렬
       x = "weight", y = "") +
  # theme_bw() ## x, y 그리드 남김
  # theme_void() ## 그냥 아예 없앰. 축이든 범례든 뭐든
  theme_classic() ## x, y 그리드 없앰


### EX2. 처리 집단에 따른 범주별 히스토그램 분할
ggplot(PlantGrowth, aes(x = weight, fill = group)) + ## 겹쳐짐, 쓰레기
  geom_histogram(bins = 10)

#### y축으로 분할
ggplot(PlantGrowth, aes(x = weight, fill = group)) +
  geom_histogram(bins = 10) +
  labs(title = "식물의 건조중량 히스토그램", y = "") +
  facet_grid(group~.) ## x축을 또 다른 변수로 분할할경우 ~뒤에 지정. 아니면 `.`

#### x축으로 분할 : 분포를 비교하는 입장에서 바람직하지 않음
ggplot(PlantGrowth, aes(x = weight, fill = group)) +
  geom_histogram(bins = 10) +
  labs(title = "식물의 건조중량 히스토그램", y = "") +
  facet_grid(.~group)

#### 그룹 라벨 변경 - 기존 데이터프레임 변조 없이
labels <- c("ctrl" = "대조군", "trt1" = "실험군A", "trt2" = "실험군B")

ggplot(PlantGrowth, aes(x = weight, fill = group)) +
  geom_histogram(bins = 10) +
  labs(title = "식물의 건조중량 히스토그램", y = "") +
  facet_grid(group~.,
             labeller = labeller(group = labels)) + ## 폰트 사이즈 깨짐
  theme(plot.title = element_text(size = 25, hjust = 0.5),
        axis.title = element_text(size = 15),
        axis.text = element_text(size = 15),
        strip.text = element_text(size = 20, face = "bold"), ## facet label text
        legend.position = "none")



##----------C. 상자 그림----------
install.packages("palmerpenguins")
library(palmerpenguins)

penguins$species %>% levels


### EX1. 세워진 상자 그림
penguins %>%
  drop_na() %>%
  ggplot(aes(y = body_mass_g)) +
  geom_boxplot() ## 전체 분포는 오른쪽으로 기울어진 분포 느낌


### EX2. 눕힌 상자 그림
penguins %>%
  drop_na() %>%
  ggplot(aes(x = body_mass_g)) +
  geom_boxplot()


## Date : 2025-05-28
## Author : 강신성
## Student code : 202014107
## Title : 데이터 시각화

#----------ggplot2----------#
setwd("C:/Users/default.DESKTOP-VHFHFGU/Downloads")
library(tidyverse)

##----------C. 상자 그림----------
library(palmerpenguins)


## EX1. 품종에 따른 상자 그림
penguins %>%
  drop_na() %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot(aes(fill = species), ## 여기서도 aes 그대로 사용 가능
               width = 0.5) + ## 상자의 너비 조정
  labs(title = "Boxplot of Body Mass by Species", x = "", y = "Weight (g)") +
  theme_classic() +
  theme(plot.title = element_text(size = 20, margin = margin(b = 15)),
        axis.title.y = element_text(size = 15, margin = margin(r = 10)),
        axis.text = element_text(size = 12),
        legend.position = "none")


## EX2. facet_grid를 이용 : 서식지, 성별
fig <- penguins %>%
  drop_na() %>%
  ggplot(aes(x = island, y = body_mass_g, fill = island)) +
    geom_boxplot(width = 0.5) +
    facet_grid(sex ~ species) +
    labs(x = "", y = "Weight (g)") +
    theme_bw() +
    theme(axis.title.y = element_text(size = 15, margin = margin(r = 15)),
          axis.text = element_text(size = 12),
          strip.text = element_text(size = 15, face = "bold"), ## 내부 타이틀
          legend.position = "none",
          panel.grid.major.x = element_blank(), ## x 그리드 없앰
          panel.grid.minor = element_blank() ## 자잘한 눈금 없앰
          )

fig

### 상자별 분포 파악하기
fig + geom_point(color = "steelblue", alpha = 0.5)
fig + geom_jitter(color = "steelblue", alpha = 0.5, width = 0.2) ## 지터링



##----------D. 산점도-----------

## EX1. 날개 길이와 몸무게 간 산점도
penguins %>%
  drop_na() %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(size = 4, color = "forestgreen", pch = 17, alpha = 0.5) +
  labs(x = "Flipper Length", y = "Weight (g)",
       title = "펭귄 지느러미 길이와 몸무게 간 산점도") +
  theme_bw() +
  theme(plot.title = element_text(size = 15, hjust = 0.5),
        axis.title.x = element_text(size = 12, margin = margin(t = 10)),
        axis.title.y = element_text(size = 12, margin = margin(r = 10))) +
  geom_smooth(method = lm, color = "red") +
  geom_rug() ## 데이터의 단변량 분포 느낌...


tmp <- penguins %>% drop_na()
cor(tmp$flipper_length_mm, tmp$body_mass_g)
model <- lm(body_mass_g ~ flipper_length_mm, penguins)
summary(model)


## EX2. 날개 길이와 체중에 대한 산점도 + 품종별 색상 및 모양 구분
penguins %>%
  drop_na() %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, pch = species), size = 4, alpha = 0.5)


## EX3. 날개 길이와 체중에 대한 산점도 + 부리 길이 색상 구분 -> 클수록 부리길이도 김
penguins %>%
  drop_na() %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = bill_length_mm), size = 4, alpha = 0.6) +
  scale_color_gradient(low = "cyan", high = "red") ## 그라데이션 설정


## EX4. 날개 길이와 체중에 대한 산점도 + 부리 길이 크기 구분 + 성별 색상 구분
penguins %>%
  drop_na() %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g, color = sex, size = bill_length_mm)) +
  geom_point(alpha = 0.6)

##
## 두 개 이상의 집단으로 나뉜 것 같고, 집단에 따라 암컷의 부리 길이가 짧음
##


## Date : 2025-05-26
## Author : 강신성
## Student code : 202014107
## Title : 데이터 시각화

#----------ggplot2----------##
setwd("C:/Users/default.DESKTOP-VHFHFGU/Downloads")
library(tidyverse)
library(lubridate)


##----------지난 시간에 왜 이렇게 그렸대 했던 것----------
library(palmerpenguins)
penguins %>%
  drop_na() %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot(aes(fill = species), width = 0.5) +
  coord_flip() ## 다 하고 축을 바꿀 때 사용

##----------G. 선그래프----------
## 시간에 따른 이름에 "x"가 포함되는 아이의 비율 변화
library(babynames)

babynames %>%
  group_by(year) %>%
  summarize(prop_x = mean(str_detect(name, "x"))) %>%
  ggplot(aes(x = year, y = prop_x)) +
    geom_line(size = 1, color = "steelblue") +
    labs(x = "Year", y = "Prop", title = "시간별 이름에 \"x\"가 포함되는 아이의 비율 변화") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))


## 시간에 따른 대륙별 기대 수명의 중앙값 변화
install.packages("wesanderson") ## 다채로운 컬러 팔레트
install.packages("gapminder") ## 데이터
library(wesanderson)
library(gapminder)

gapminder %>%
  group_by(year, continent) %>%
  summarise(LifeMedian = median(lifeExp)) %>%
  ggplot(aes(x = year, y = LifeMedian, color = continent)) +
    geom_line(size = 1) +
    geom_point(size = 4, pch = 21, fill = "white") + ## 레이어 방식이므로 순서 중요
    labs(x = "Year", y = "Median of Life Expectation", title = "연도에 따른 대륙별 기대 수명의 중앙값") +
    theme_bw() + ## 테마 프리셋 적용 시 커스텀보다 먼저 와야 함
    theme(plot.title = element_text(size = 15, hjust = 0.5, face = "bold"),
          axis.title.x = element_text(margin = margin(t = 10)),
          axis.title.y = element_text(margin = margin(r = 10))
          ) +
    # theme_bw() ## 이러면 위에 썼던 테마 설정 다 덮어씌워짐
    scale_color_manual(values = wes_palette("Darjeeling1", 5)) ## 팔레트 프리셋