rm(list = ls())
setwd("C:/Users/hollyriver/Documents/Github/R/탐색적자료분석/data")

dt <- read.csv("gloval GNP.csv", header = TRUE)
colnames(dt) = c("국가명", "1인당 GNP")
str(dt)

x <- dt[,2]

stem(x, scale = 2)
boxplot(x, ylab = "달러")

#-------모평균에 대한 95% 신뢰구간-------

n <- length(x)  ## 자료 수

x_bar <- x |> mean()  ## 점추정치

sigma_x <- sd(x)  ## 표본분산

se_x <- sigma_x/sqrt(n)

lwb <- (x_bar - qnorm(0.975)*se_x) |> round(4)
upb <- (x_bar + qnorm(0.975)*se_x) |> round(4)

print(paste("모평균에 대한 95% 근사신뢰구간 : (", lwb, ", ", upb, ")", sep = ""))

#-------대칭화 변환-------

num <- quantile(x, c(0, 0.25, 0.5, 0.75, 1), type = 8)
H_L <- num[2]
M <- num[3]
H_U <- num[4]


app_p <- 1 - ((H_L + H_U)/2 - M)/(((H_L - M)^2 + (H_U - M)^2)/(4*M))  ## 근사적인 p값
app_p

par(mfrow = c(1,2))
boxplot(x^app_p)
boxplot(x)

stem(x^app_p)
stem(x)

hist(x, breaks = 20)

boxplot(log(x), ylab = "log(달러)")
stem(log(x))

mu_trans <- mean(log(x))
sd_trans <- sd(log(x))
lwb_trans <- mu_trans - qnorm(0.975)*sd_trans
upb_trans <- mu_trans + qnorm(0.975)*sd_trans

print(paste("대수변환된 모평균에 대한 95% 근사신뢰구간 : (", lwb_trans, ", ", upb_trans, ")", sep = ""))

#-------변수 변환-------
df <- data.frame(dist = c(12:22),
           size = c(12, 9.4, 7.2, 6.2, 5.2, 4.5, 4.0, 3.6, 3.2, 3.0, 2.7))

plot(dist~size, df)

trans_size = 1/df$size

plot(df$dist, trans_size, xlab = "dist", ylab = "inverse size")
