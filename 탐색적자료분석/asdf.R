rm(list = ls())

norm_sample <- rnorm(100)  ## 표준정규분포
chi_sample <- rchisq(100, 2)  ## 카이제곱분포
beta_sample <- rbeta(100, 10, 2)  ## 베타분포

par(mfrow = c(3,1))
hist(norm_sample, main = expression(N(0,1)), breaks = 10)
hist(chi_sample, main = expression(chi^2~(2)), breaks = 10)
hist(beta_sample, main = expression(beta(10,2)), breaks = 10)

chr_display <- function(sample) {
  lwv = quantile(sample, c(0.5, 0.25, 0.125, 0.0625, 0), type = 8)
  upv = quantile(sample, 1 - c(0.5, 0.25, 0.125, 0.0625, 0), type = 8)
  
  temp = cbind(lwv, upv)
  rownames(temp) = c("중앙값", "4분위수", "8분위수", "16분위수", "끝값")
  
  return(data.frame(temp, mid = apply(temp, 1, mean), spr = upv - lwv))
}

chr_display(norm_sample)
chr_display(chi_sample)
chr_display(beta_sample)


#-------여러 박스 플롯-------

data("mtcars")
boxplot(mpg~cyl,data=mtcars, main="Car Milage Data",
        xlab="Number of Cylinders", ylab="Miles Per Gallon")


data("ToothGrowth")
boxplot(len~supp*dose, data=ToothGrowth, notch=TRUE,
        col=(c("gold","darkgreen")),
        main="Tooth Growth", xlab="Suppliment and Dose")


install.packages("vioplot")
library(vioplot)

x1 <- mtcars$mpg[mtcars$cyl == 4]
x2 <- mtcars$mpg[mtcars$cyl == 6]
x3 <- mtcars$mpg[mtcars$cyl == 8]

vioplot(x1, x2, x3, names = c("4 cyl", "6 cyl", "8 cyl"), col = "gold")
title("Violin Plots of Miles Per Gallon")


library(aplpack)
attach(mtcars)
bagplot(wt, mpg, xlab="Car Weight", ylab="Miles Per Gallon",
        main="Bagplot Example")


#-------전라북도 시군별 인구수-------

setwd("C:/Users/hollyriver/Documents/Github/R/탐색적자료분석/data/")
dt <- read.csv("Jeonbuk-population.csv", header = TRUE)
head(dt)

colnames(dt) <- dt[1,]
featured_dt <- dt[-1,c(1,3)]
rownames(featured_dt) <- NULL
str(featured_dt)

featured_dt[2] <- as.numeric(featured_dt[[2]])

x = 0
lst = c()
domain = ""

for (i in 1:nrow(featured_dt)) {
  if (substr(featured_dt[i,1], 3, 3) == "시") {
    x = x + 1
    lst = c(lst, "시")
    domain = featured_dt[i,1]
  }
  else if (substr(featured_dt[i,1], 3, 3) == "군") {
    x = x + 1
    lst = c(lst, "군")
    domain = featured_dt[i,1]
  }
  else {
    lst = c(lst, domain)
  }
}


featured_dt <- cbind(featured_dt, 구분 = lst)
featured_dt <- featured_dt[-which(featured_dt[3] == "시" | featured_dt[3] == "군"),]
rownames(featured_dt) <- NULL
colnames(featured_dt) <- c("행정구역(읍면동)", "인구수", "구분")
featured_dt$구분 <- factor(featured_dt$구분, levels = unique(featured_dt$구분))

si_dt <- featured_dt[1:156,]
si_dt$구분 <- factor(si_dt$구분, levels = unique(si_dt$구분))
gun_dt <- featured_dt[157:243,]
gun_dt$구분 <- factor(gun_dt$구분, levels = unique(gun_dt$구분))

dev.new()
boxplot(인구수~구분, si_dt, xlab = "시", main = "전라북도 소재 시 지역내 읍면동 인구수")
boxplot(인구수~구분, gun_dt, xlab = "군", main = "전라북도 소재 군 지역내 읍면동 인구수")
boxplot(인구수~구분, featured_dt, col = rep(c("cyan", "green"), c(6,8)), xlab = "시-군", main = "전라북도 소재 시-군 지역내 읍면동 인구수")
legend(x = "topright", legend = c("시", "군"), fill = c("cyan", "green"))