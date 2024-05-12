library(MASS)

set.seed(1234567)
x = seq(1, 10)
y = 2.5 + 0.5*x + rnorm(10, 0, 1)
y[10] = -10

sum_lm_res = sum(lm(y~x)$residuals)
sum_rlm_res = sum(rlm(y~x)$residuals)
sum_lms_res = sum(lqs(y~x, method = "lms")$residuals)
sum_lts_res = sum(lqs(y~x, method = "lts")$residuals)
sum_lts8_res = sum(lqs(y~x, method = "lts", quantile = 8)$residuals)

print(paste("lm의 잔차합 : ", round(sum_lm_res, 5), sep = ""))
print(paste("rlm의 잔차합 : ", round(sum_rlm_res, 5), sep = ""))
print(paste("lms의 잔차합 : ", round(sum_lms_res, 5), sep = ""))
print(paste("lts의 잔차합 : ", round(sum_lts_res, 5), sep = ""))
print(paste("lts(quantile = 8)의 잔차합 : ", round(sum_lts8_res, 5), sep = ""))


data(stackloss)
attach(stackloss)

str(stackloss)


m1 = lm(stack.loss~., stackloss)
m2 = rlm(stack.loss~., stackloss)
m3 = lqs(stack.loss~., stackloss, method = "lms")
m4 = lqs(stack.loss~., stackloss, method = "lts", quantile = 16)

dev.new()
boxplot(m1$resid, m2$resid, m3$resid, m4$resid, ylab = "residuals",
        xlab = "LS-M-LMS-LTS Regression (from left to right)")
