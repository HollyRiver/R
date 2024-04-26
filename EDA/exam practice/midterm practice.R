setwd("C:\\Users\\hollyriver\\Documents\\Github\\R\\EDA\\data\\")

rm(list = ls())


rain <- data.frame(acid = t(read.table("acid rain.txt")))
rownames(rain) = NULL
rain |> head()

library(aplpack)
stem.leaf(rain$acid, m = 0.5)

## 자료의 범위는 4.12에서 5.57, 한 개의 군집, 5.5를 넘는 이상치 셋, 구간 4.3에 가장 집중되어있고, 오른쪽으로 기울어진 분포

hist(rain$acid)

## 정보가 소실됨, 하지만 구간을 나누는 것이 자유로움.

stem.leaf(rain$acid, unit = 0.1, m = 2)

king <- read.table("chosun kings.txt", header = T, fileEncoding = "CP949", encoding = "UTF-8")  ## 염병 왜 안읽혀
king

str(king)
stem.leaf(king$Life, m = 1)

exam <- read.table("exam1.txt", header = T)
x <- sort(exam$score)
quantile(x, c(0.5, 0.25, 0.125, 0.0625), type = 8)

length(x)

65*0.5 + 0.5/3 + 1/3  ## 33
x[33]

65*0.25 + 0.25/3 + 1/3  ## 16 + 2/3
x[16]*1/3 + x[17]*2/3

65*0.125 + 0.125/3 + 1/3  ## 8 + 1/2
x[8]*1/2 + x[9]*1/2

65*0.0625 + 0.0625/3 + 1/3  ## 4 + 2/5 + 1/60 = 4 + 5/12
x[4]*7/12 + x[5]*5/12

lwv <- quantile(x, c(0.5, 0.25, 0.125, 0.0625, 0), type = 8)
upv <- quantile(x, 1-c(0.5, 0.25, 0.125, 0.0625, 0), type = 8)
mid <- (lwv + upv) / 2
spr <- upv - lwv

value_summarize <- data.frame(lower = lwv, upper = upv, mid = mid, spr = spr)
rownames(value_summarize) = c("M", "H", "E", "D", "end")
value_summarize

hist(exam$score)

skew = ((value_summarize[2, 2] - value_summarize[1,2]) - (value_summarize[1, 2] - value_summarize[2,1]))/value_summarize[2,4]
skew

kurto_EH = spr[3]/spr[2] - 1.704; kurto_EH  ## 정규분포보다 이상치가 많음(퍼져있는 분포)
kurto_DH = spr[4]/spr[2] - 2.274; kurto_DH

## lambda/2 * exp(-lambda*abs(x-mu))

f1 <- function(x) {1/sqrt(2*pi)*exp(-x^2/2)}
f2 <- function(x) {1/4*exp(-1/2*abs(x))}

curve(f1, -4, 4, ylim = c(0, 0.5))
curve(f2, add = T, lty = 2)

0.675 + 1.5*1.35


population <- read.csv("광역시-구 인구.csv", header = TRUE, fileEncoding = "CP949", encoding = "UTF-8")
str(population)

boxplot(population$인구~population$지역명, main = "7개 광역시의 구별 인구 비교", xlab = "지역명", ylab = "인구")
dev.new()

domain <- reorder(population$지역명, population$지역코드)  ## convert as factor by local number
boxplot(population$인구~domain)

class(domain)

library(MASS)
data(iris)
boxplot(iris$Sepal.Length)

## 자료의 범위는 4.2에서 7.9정도이고, 5.8에 중앙값이 자리하고 있다.
## 아래경첩의 값은 5.1, 위 경첩의 값은 6.4로, 5.1과 6.4 사이에 절반의 자료가 존재함을 알 수 있다.
## 이상치가 존재하지 않는다.
## 중앙값과 위경첩의 차이와, 아래경첩과의 차이가 거의 차이가 나지 않아 거의 대칭인 분포일 것이라고 기대해볼 수 있다.

hist(iris$Sepal.Length)


income <- c(880, 1511, 1944, 2350, 2738, 3135, 3609, 4170, 5068, 7695)
par(mfcol = c(1,2))
plot(income)
plot(log(income))


x1 <- rgamma(100, 4)
x2 <- rgamma(100, 5)
x3 <- rgamma(100, 9)

claims <- c(x1, x2, x3)
group <- rep(c("A", "B", "C"), c(100, 100, 100))

par(mfcol = c(1,3))
boxplot(claims~group)
boxplot(sqrt(claims)~group)
boxplot(log(claims)~group)

data("Animals")

hist(Animals$body, breaks = 50)
hist(Animals$brain, breaks = 50)
## 오른쪽으로 심하게 기울어져 있으므로 로그변환

m1 <- lm(log(Animals$brain)~log(Animals$body))
m2 <- rlm(log(Animals$brain)~log(Animals$body))

dev.new()
par(mfcol = c(1,2))
plot(log(Animals$body), log(Animals$brain))
abline(m1)
plot(log(Animals$body), log(Animals$brain))
abline(m2)


x <- rnorm(100, 40, 10)
y <- c(rnorm(90, 40, 10), rnorm(10, 80, 5))
z_x <- (x - mean(x))/sd(x)
z_y <- (y - mean(y))/sd(y)
rob_z_x <- (x - median(x))/(IQR(x)/1.35)
rob_z_y <- (y - median(y))/(IQR(y)/1.35)

dev.new()
par(mfrow = c(2,2))
hist(z_x, xlim = c(-4, 4), breaks = 10)
hist(z_y, xlim = c(-4, 4), breaks = 10)
hist(rob_z_x, xlim = c(-4, 4), breaks = 10)
hist(rob_z_y, xlim = c(-4, 4), breaks = 10)


library(MASS)
data(Animals)

x <- Animals$brain

H_L <- fivenum(x)[2]
H_U <- fivenum(x)[4]
M <- fivenum(x)[3]

app_p <- 1 - ((H_L+H_U)/2 - M)/(((H_U - M)^2+(H_L - M)^2)/(4*M))
app_p

par(mfcol = c(1,3))
hist(x)
hist(x^app_p)
hist(log(x))

par(mfcol = c(1,1))

hist(x^0.5, breaks = 10)
hist(x^0.25, breaks = 10)
hist(x^0.125, breaks = 10)  ## 가장 대칭에 가까움. p = 1/8
hist(log(x), breaks = 10)

y <- iris$Sepal.Length
x <- iris$Species

boxplot(y~x, xlab = "Species", ylab = "Length of sepal", main = "종별 꽃잎의 길이 비교")

unique(iris$Species)

spr = c()
med = c()

for (i in 1:3) {
  temp_dt <- iris$Sepal.Length[iris$Species == unique(iris$Species)[i]]
  temp_quant <- fivenum(temp_dt)
  spr = c(spr, temp_quant[4] - temp_quant[2])
  med = c(med, temp_quant[3])
}

trans_spr = log(spr)
trans_med = log(med)

as.numeric(lm(trans_spr~trans_med)$coef[2])  ## 1-p

p = 1-as.numeric(lm(trans_spr~trans_med)$coef[2])

boxplot(y^p~x, xlab = "Species", ylab = "transported length of sepal")

## p가 음수이므로 역변환에 속함. 따라서 virginica의 길이가 가장 길고, 다음으로 versicolor, setosa라고 할 수 있음.


darwin <- c(49, -67, 8, 16, 6, 23, 28, 41, 14, 29, 56, 24, 75, 60, -48)
qqnorm(darwin)
qqline(darwin)

length(darwin)  ## 15

p_i <- (1:15 - 0.5)/15
q_i <- sort(darwin)
plot(q_i~qnorm(p_i))

O_i <- c(150, 160, 165, 155, 170, 200)
E_i <- rep(166.7, 6)

diff <- c()

for (i in 1:6) {
  diff = c(diff, (O_i[i] - E_i[i])^2/E_i[i])
}

sum(diff)  ## test statistics
sum(diff) >= qchisq(0.95, 6 - 1)  ## False, accept H_0

# H_0 : 확률이 1/6인 균등분포를 따른다 vs. H_1 : not H_0


## H_0 : 아이들이 3명인 가구의 남아의 수는 n = 3, p = 0.5인 이항분포를 따른다. vs. H_1 : not H_0

O_i <- c(100, 350, 400, 150)
E_i <- c()

for (i in 0:3) {
  E_i <- c(E_i, dbinom(i, 3, 0.5))
}

E_i <- E_i*1000; E_i

diff = c()

for (i in 1:4) {
  diff <- c(diff, (O_i[i] - E_i[i])^2/E_i[i])
}

sum(diff)  ## test statistics
sum(diff) >= qchisq(0.95, 4-1)  ## reject H_0. 따라서 남녀출산의 비율이 0.5라고 할 수 없다.


## H_0 : 분포가 포아송분포를 따른다 vs. H_1 : not H_0

O_i = c(109, 62, 22, 3, 1)
lambda <- sum(O_i*0:4)/200; lambda

E_i <- c()

for (i in 0:3) {
  E_i = c(E_i, dpois(i, lambda))
}

E_i = c(E_i, ppois(4, lambda, lower.tail = FALSE))
E_i = E_i*200; E_i

diff <- c()

for (i in 1:4) {
  diff <- c(diff, (O_i[i] - E_i[i])^2/E_i[i])
}

sum(diff)

sum(diff) >= qchisq(0.95, 5-1-1)  ## accept H_0 즉, 포아송분포를 따른다.

leukemia <- c(1, 1, 2, 2, 3, 4, 4, 5, 5, 8, 8, 8, 8, 11, 11, 12, 12, 15, 17, 22, 23)

n <- length(leukemia)
p <- (1:n - 0.5)/n
q <- qnorm(p)
q_exp <- qexp(p)
q_weibull <- qweibull(p, 1.5)
x <- sort(leukemia)

plot(q, x, pch = 16, xlab = "Theorical quantile", ylab = "Sample quantile", main = "QQ plot for Normal distribution")
plot(q_exp, x, pch = 16, xlab = "Theorical quantile", ylab = "Sample quantile", main = "QQ plot for Exponential distribution")
plot(q_weibull, x, pch = 16, xlab = "Theorical quantile", ylab = "Sample quantile", main = "QQ plot for Weibull distribution")

## 와이블분포는 지수분포를 포함하니까, 그냥 왠만해서는 지수분포가 나올듯 하다.

fitdistr(leukemia, "weibull")

plot(qweibull(p, 1.37), x, pch = 16, xlab = "Theorical quantile", ylab = "Sample quantile", main = "QQ plot for Weibull distribution")

x <- rbeta(800, 2, 3)*100
y <- rbeta(1200, 3, 2)*100

fivenum(x)
fivenum(y)