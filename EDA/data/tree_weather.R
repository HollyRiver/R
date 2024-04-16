# section 14.1
library(rattle)
data(weather)
str(weather)
names(weather)

library(rpart)
tree.1 <- rpart(RainTomorrow ~ ., data=weather[,c(3:22,24)])
plot(tree.1, main="weather", margin=0.025)
text(tree.1, use.n = TRUE, all=TRUE, cex=0.8, col="blue")
tree.1

pred.1 <- predict(tree.1, type="prob")[,2]
cut <- sort(pred.1)[301]
pred.1a <- ifelse(pred.1 >= cut, "Yes", "No")
table(pred.1a, weather$RainTomorrow, dnn=c("predicted","observed"))

data(weatherAUS)
weather.2 <- subset(weatherAUS, Location=="Canberra") 
weather.2a <- weather.2[(366+1):(366+365), ] # Date from "2008-11-01" for 365 days
pred.2a <- ifelse(predict(tree.1, newdata=weather.2a, type="prob")[,2] >= cut, "Yes", "No")
table(pred.2a, weather.2a$RainTomorrow, dnn=c("predicted","observed"))

# end