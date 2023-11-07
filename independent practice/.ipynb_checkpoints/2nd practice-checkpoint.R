#------------matrix----------------

X1 <- matrix(1:20, nrow = 5, byrow = TRUE); X1
X2 <- diag(seq(1,10,length = 10), 5); X2
diag(X2)

x <- c(1:5); y <- c(5:1)
cbind(x,y)
rbind(x,y)

x <- matrix(c(1:6), ncol = 3)
y <- matrix(c(1:-4), ncol = 3)

x*y

t(x)

x%*%t(y)

A <- matrix(1:20, nrow = 3, ncol = 3); A
B <- matrix(c(1,5,2,8,3,1,5,6,8,2), nrow = 3, ncol = 3); solve(B)

Lst <- list(name = 'fred', wife = 'mary', child.ages = c(4,7,9), temp = list(
  a = 'apple', b = 'banana', c = 'carrot'
))

Lst$name
Lst[["name"]]
Lst[[1]]

Lst[2:3]
Lst[c(1,3)]

Lst$temp$c
Lst[[4]][1]

list1 <- list(a = 1, b = 1:3)
list2 <- list(a = c('kim','park'))
c(list1, list2) ## combine으로 합쳐도 리스트로 유지됨

#-----------data frame--------------

name   <- c("kim","lee","park","Oh")
sex    <- c('f','m','f','m')
income <- c(100,102,300,204)
d1     <- data.frame(name=name, gender=sex, incom=income)
d1  ## 길이가 4인 벡터들을 세 개 모아 데이터프레임으로 만듦.

## as.data.frame() 리스트나 행렬을 데이터프레임으로 변환

head(d1, 2)
tail(d1, 2)

names(d1) ## 변수명(열 인덱스) 출력 또는 지정

names(d1)[3] <- "income"
names(d1)[3]

nrow(d1)
ncol(d1)
dim(d1)

x <- c(4,6,5,7,10,9,4,15); x

p <- c (3, 5, 6, 8)
q <- c (3, 3, 3)
p+q

Age <- c(22, 25, 18, 20)
Name <- c("James", "Mathew", "Olivia", "Stella")
Gender <- c("M", "M", "F", "F")

DataFrame <- data.frame(Age, Name, Gender)
subset(DataFrame, Gender == 'M')

x <- c(1,2,3,4)
(x+2)[(!is.na(x)) & x > 0] -> k; k  ## is.na(x) : 벡터에 빈 값이 있다면 TRUE

?is.na()

x <- c(34, 56, 55, 87, NA, 4, 77, NA, 21, NA, 39)
sum(is.na(x)) ## > 3

a=c(1,2,4,5,6)
b=c(3,2,4,1,9)
cbind(a,b); dim(cbind(a,b))

x=c(1:12);x
dim(x)
length(x)

x=c('blue',10,'green',20); x  ## 벡터에선 type이 공존할 수 없음
is.character(x)

typeof(x)
typeof(c(1,2,3,4))


#-----------free style------------
matrix((1:10), ncol = 2)
x <- matrix(c(1,3,5,6,2,2,3,1,4), ncol = 3)
solve(x)
x
t(x)
rbind(x, t(x))
cbind(x, t(x))
rbind(x, diag(2,3))
colnames(x) <- c('a','b','c');x
rownames(x) <- c('d','e','f');x
names(x)

lst = list(a = 1, b = 2, 'c' = 3)
lst$a
lst$b
lst$c

lst[['a']]

y <- rep(1, 5)
y[-c(1,3)]
y[c(1,3)]
y[1:3]
y[c(1,3)]

if (rnorm(1) > 0) {
  print('up')
} else {
  print('down')
}

i = 0

while (i < 10) {
  i = i + 1
  print(i)
}

for (i in c(1:10)) {
  print(i)
}

f <- function(x) {
  x**2 + 2*x + 1
}

plot(x, f(x), type = 'l', col = 'blue', lwd = 3, main = 'test')
plot(f, type = 'l', col = 'blue', lwd = 3)

integrate(f, lower = 1, upper = 3)

dev.new()
plot(f, col = 'blue', lwd = 5)
abline(a = 1, b = 3, lwd = 3, col = 'red')