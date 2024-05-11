rm(list = ls())
data <- scan()

install.packages("sleekts")
library(sleekts)

sleek(data)

plot(data, type = 'l', main = "4253H 평활 결과")
lines(sleek(data), lwd = 2, col = "darkorange")


smooth(data, kind = "3RSS")

hanning = function(x) {
  z = c(3*x[2] - 2*x[3])  ## x_0
  N = length(x)
  z = c(z, x, (3*x[N-1] - 2*x[N-2]))  ## x_n+1
  smooth = c()
  
  for (i in 1:N) {
    smooth[i] = (z[i] + 2*z[i+1] + z[i+2])/4
  }
  
  return(smooth)
}

X_1 = hanning(smooth(data, kind = "3RSS"))
rough = data - X_1

X_2 = hanning(smooth(rough, kind = "3RSS"))

smooth_data = X_1 + X_2

plot(data, type = "l", main = "3RSSH 평활 결과")
lines(smooth_data, col = "darkorange", lwd = 2)


library(dplyr)

setwd("C:/Users/hollyriver/Desktop/분자벨")
elec_data = read.csv("HOME_발전·판매_판매전력량_월별.csv", encoding = "UTF-8", fileEncoding = "CP949")
elec_data = elec_data[order(elec_data$연도),]  ## ascending
rownames(elec_data) <- NULL
Series = ts(as.vector(t(elec_data[, -1])), start = c(2000, 1), frequency = 12)

smooth_4253H = sleek(as.vector(t(elec_data[, -1])))
rough_4253H = as.vector(t(elec_data[, -1])) - smooth_4253H
smooth_4253H_tw = smooth_4253H + sleek(rough_4253H)

smooth_3RSSH = hanning(smooth(as.vector(t(elec_data[, -1])), kind = "3RSS"))
rough_3RSSH = as.vector(t(elec_data[, -1])) - smooth_3RSSH
smooth_3RSSH_tw = smooth_3RSSH + hanning(smooth(rough_3RSSH, kind = "3RSS"))

dev.new()
par(mfrow = c(2, 1))
plot(Series, main = "2000~2022년 판매전력량", ylab = "elec use (MWh)")
lines(ts(smooth_4253H_tw, start = c(2000, 1), frequency = 12), col = "darkorange", lwd = 2)
legend("bottomright", legend = c("원 자료", "4253H"), col = c("black", "darkorange"), lty = 1)

plot(Series, main = "2000~2022년 판매전력량", ylab = "elec use (MWh)")
lines(ts(smooth_3RSSH_tw, start = c(2000, 1), frequency = 12), col = "darkblue", lwd = 2)
legend("bottomright", legend = c("원 자료", "3RSSH"), col = c("black","darkblue"), lty = 1)


decomp_serise = decompose(log(Series))

dev.new()
par(mfrow = c(1, 2))
plot(exp(window(decomp_serise$seasonal, start = 2021)), ylab = "season",
     main = expression(paste("계절성(", S[t], ")의 그래프")), cex.main = 3)
plot(exp(decomp_serise$trend), ylab = "trend",
     main = expression(paste("추세(", T[t], ")의 그래프")), cex.main = 3)

dev.new()
acf(as.vector(t(elec_data[, -1])))

as.vector(t(elec_data[, -1]))


rice_data = c(5291, 5515, 4927, 4451, 5000,
              4768, 4680, 4408, 4843, 4916,
              2495, 4224, 4006, 4230, 4241,
              4327, 4197, 3972, 3868, 3744,
              3507, 3882, 3764, 3702)
Series = ts(rice_data, start = 2000)

smooth_4253H = sleek(Series)
rough_4253H = Series - smooth_4253H
smooth_4253H_tw = smooth_4253H + sleek(rough_4253H)

smooth_3RSSH = hanning(smooth(Series, kind = "3RSS"))
rough_3RSSH = Series - smooth_3RSSH
smooth_3RSSH_tw = smooth_3RSSH + hanning(smooth(rough_3RSSH, kind = "3RSS"))

dev.new()
par(mfrow = c(2, 1))
plot(Series, main = "2000~2023년 국내 쌀 생산량", ylab = "쌀 생산량(만 톤)", ylim = c(0, 6000))
lines(ts(smooth_4253H_tw, start = 2000), col = "darkorange", lwd = 2)
legend("bottomright", legend = c("원 자료", "4253H"), col = c("black", "darkorange"), lty = 1)

plot(Series, main = "2000~2023년 국내 쌀 생산량", ylab = "쌀 생산량(만 톤)", ylim = c(0, 6000))
lines(ts(smooth_3RSSH_tw, start = 2000), col = "darkblue", lwd = 2)
legend("bottomright", legend = c("원 자료", "3RSSH"), col = c("black","darkblue"), lty = 1)

decompose(log(Series))

t = seq(1, 50)
noise = rnorm(50, 0, 1)
y = sin(2*t) + noise

dev.new()
plot(y, type = 'l', main = expression(paste(y[t], "의 그래프")), xlab = "Time")

dev.new()
acf(y, ylim = c(-1, 1), main = "y의 ACF")
