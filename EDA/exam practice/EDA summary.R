#-------setting-------

rm(list = ls())
library(aplpack)  ## stem.leaf.backback()
library(MASS)
library(dplyr)
library(readxl)
library(ggplot2)

#-------basic-------

data("Aids2")
ls()
attach(Aids2)
detach(Aids2)
head(Aids2)
str(Aids2)  ## structure
hist(death) ## histogram
length(death)

A = matrix(1:9, ncol = 3, byrow = TRUE)
B = list(a = "apple", b = c("banana", "boolean"), c = matrix(1:9, nrow = 3))
cbind(A, B[["c"]]); rbind(A, B[["c"]])
array(1:12, c(3, 2, 2))
eigen(t(A)%*%A, symmetric = T)

seq(1, 10, by = 2)
seq(1, 10, length = 4)
rep(1, 5)

X = rnorm(100); X[which(X > 0)]
which(X > 0)

x = c(1,2,3,NA); mean(x, na.rm = T)

fact_dt = factor(c(1,2,2,3), levels = 1:3)
levels(fact_dt) = c("sans", "pap", "toriel"); fact_dt
table(fact_dt)

d = list(d1 = c(1,2,3,4), d2 = c(2,3,4,5))
tr = transform(d, tot = d1+d2)
class(tr)

aa = c(12, 5, 6, 3, 1)
sort(aa)
order(aa)
rank(aa)

apply(Aids2[, 3:4], 2, sum); lapply(Aids2[, 3:4], sum)  ## lapply는 axis = 2만 가능

data("geyser")
plot(geyser$waiting~geyser$duration, xlim = c(0.6, 6), ylim = c(40, 110), xlab = "duration", ylab = "waiting", main = "geyser", type = "n")
text(geyser$waiting~geyser$duration, cex = 0.5)

par(mfrow = c(2,2))
hist(rbeta(400, 1, 1), breaks = seq(0, 1, 0.1), prob = T, ylim = c(0, 3))
hist(rbeta(400, 2, 2), breaks = seq(0, 1, 0.1), freq = F, ylim = c(0, 3))
hist(rbeta(400, 4, 4), breaks = seq(0, 1, 0.1), prob = T, ylim = c(0, 3))
hist(rbeta(400, 8, 8), breaks = seq(0, 1, 0.1), freq = F, ylim = c(0, 3))
par(mfrow = c(1,1))

x = seq(-6, 6, 0.01); m = 0; s = sd(rt(1000, 5))
hist(rt(1000, 5), prob = T, breaks = 20)
curve(dnorm(x, m, s), add = T)

read.csv("file name", header = T)

#-------stem and leaf plot-------

# library(aplpack)
stem.leaf.backback(head(Aids2$death, 50), tail(Aids2$death, 40))

data("Boston")
x <- Boston$medv
stem.leaf(x, unit = 0.1, m = 1)  ## m으로 스케일 조절
stem(x, scale = 2)  ## scale과 m은 거의 그냥 똑같음
hist(x, breaks = 20)

#-------values display and box plot-------

x <- rnorm(65)

lwb <- quantile(x, c(0.5, 0.25, 0.125, 0.0625), type = 8)
upb <- quantile(x, 1 - c(0.5, 0.25, 0.125, 0.0625), type = 8)
spr <- upb - lwb
mid <- (upb + lwb) / 2

stat_display <- data.frame(lwb, upb, mid, spr, row.names = c("M", "H", "E", "D"))
stat_display

library(ggplot2)
data("iris")

ggplot(iris, aes(Species, Sepal.Length)) +
  geom_boxplot()

boxplot(Sepal.Length~Species, iris, xlab = "종", ylab = "꽃받침 길이", main = "종별 상자 그림")

spr = c()
med = c()
for (i in 1:3) {
    temp_dt = iris[iris$Species == unique(iris$Species)[i],]
    spr[i] = fivenum(temp_dt$Sepal.Length)[4] - fivenum(temp_dt$Sepal.Length)[2]
    med[i] = fivenum(temp_dt$Sepal.Length)[3]
}
trans_spr = log(spr)
trans_med = log(med)
lm(trans_spr~trans_med)  ## 1-p = 2.267, p = -1.167

boxplot(iris$Sepal.Length^(-1.167)~Species, iris, xlab = "Species", ylab = "transformed Sepan Length", main = "변환된 상자 그림")  ## 분포가 비슷해졌당
boxplot(Sepal.Length~Species, iris, notch = TRUE)

#-------probability plot using-------

dbinom(0, 3, 0.5); dbinom(1, 3, 0.5); dbinom(2, 3, 0.5); dbinom(3, 3, 0.5) # frequency table

n = 100
x <- rnorm(100)
p_i <- (seq(1:n) - 0.5)/n
p_norm <- pnorm(sort(x))

plot(p_norm~p_i, xlab = "Theorical probability", ylab = "Sample probability", main = "PP plot")
abline(0, 1)

q_i <- sort(x)
q_norm <- qnorm(p_i)

par(mfcol = c(1, 2))
plot(q_i~q_norm, xlab = "Theorical quantiles", ylab = "Sample quantiles", main = "QQ plot")
abline(0, 1)

qqnorm(x)
qqline(x)

par(mfcol = c(1,1))
q_i <- sort(rexp(n, 0.5))
q_exp <- -log(1-p_i)
plot(q_exp, q_i, xlab = "Theorical Quantiles", ylab = "Sample Quantiles", main = "Exponential Q-Q plot")