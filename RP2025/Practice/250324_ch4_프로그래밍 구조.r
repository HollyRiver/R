### Date : 2025-03-24
### Author : Hollyriver
### Title : 4. Programming Architecture

##----------2. Conditional Statement----------
### 1. if statement
## ex)
score <- 85

if (score >= 80) {
  print("Pass")
}

if (score >= 80) print("Pass")

### 2. if-else statement
score <- 75

if (score >= 80) {
  print("Pass")
} else {
  print("Fail")
}

if (score >= 80) print("Pass") else print("Fail") ## one line all discription

## pass or fail
if (score >= 80) {
    print("Pass")
      } else {
  print("Fail")
}

### 3. ifelse()
score <- 85
result <- ifelse(score >= 80, "Pass", "Fail") ## ifelse(bool, arg_T, arg_F)
print(result)

### 4. else if
score <- 85

if (score >= 90) {
  grade <- "A"
} else if (score >= 80) {
  grade <- "B"
} else if (score >= 70) {
  grade <- "C"
} else if (score >= 60) {
  grade <- "D"
} else {
  grade <- "F"
}

print(grade)

##----------3. Reputative Statement----------
### 1. for
#### summation
for (i in 1:5) {
  print("*")
}

#### "cat"
for (i in 1:9) {
  print(cat("2 ??", i, "=", 2*i))
}

output <- ""

for (i in 1:9) {
  output <- cat(output, "2 ??", i, "=", 2*i, "\n")
}


#### 1~20 only pair num
for (i in 1:20) {
  if (i %% 2 == 0) {
    print(i)
  }
}

#### 1~n summation
sum <- 0
n <- 100

for (i in 1:n) {
  sum <- sum + i
}

print(sum)

### 2. while
#### 1~100 summation
sum <- 0
i <- 1

while (i <= 100) {
  sum <- sum + i
  i <- i + 1
}

print(sum)

### 3. break/next
## summation 1~100 : while
sum <- 0
i <- 1

while (TRUE) {
  sum <- sum + i
  i <- i + 1
  
  if (i > 100) {
    break
  }
}

## summation 1~10 only pair numbers with next
sum <- 0

for (i in 1:10) {
  if (i%%2 == 0) {
    next
  }
  sum <- sum + i
}


### 4. apply family
#### apply(obj, MARGIN, func)
dim(iris) ## last col is string
apply(iris[, 1:4], 1, mean) ## obj, axis(starting with 1), func
## mean with all rows

apply(iris[, -5], 2, mean)  ## mainly using
## 컴프리헨션 마려운 함수

#### lapply(obj, func)
res <- lapply(iris[, 1:4], summary)  ## saving as colnames
res$Sepal.Length

#### sapply(obj, func)
res <- sapply(iris[, 1:4], summary)
res  ## matrix / array

class(apply(iris[, 1:4], 2, summary)) ## same with sapply

#### vapply(obj, func, format)
vapply(iris[, 1:4], mean, numeric(1)) ## not well known

#### tapply(obj1, obj2;grouping, func) -> groupby
tapply(iris$Sepal.Length, iris$Species, mean)
tapply(iris[, 1:4], iris$Species, summary)

#### mapply(func,  obj1, obj2, ...)
mapply(sum, iris$Sepal.Length, iris$Sepal.Width)
apply(iris[, 1:2], 1, sum)  ## same method

##----------4. costomizating function----------
### input 2 numbers, return bigger one
mymax <- function(x, y) {
  if (x > y) {
    return(x)
  } else {
    return(y)
  }
}

mymax(1, 2)

mymax <- function(x, y) {
  max_value <- x
  
  if (x < y) max_value <- y
  
  return(max_value)
}

### setting default value
### input 2 numbers x, y. return x/y
### but, default value of y is 2
mydiv <- function(x, y = 2) {
  return(x/y)
}

mydiv(0.1, 40)
mydiv(y = 50, x = 1)
mydiv(10)

### return more values
### input parameters x, y. return sum/product as list
myfunc <- function(x, y) {
  return(list(sum = x+y, product = x*y))
}

myfunc(0.6, 8)
myfunc(0.6, 0)
myfunc(0, 15)

res <- myfunc(5, 8)
res$sum
res$product

unlist(res)

##----------5. R Packages----------
.libPaths() ## show library path
install.packages("tidyverse")
library(tidyverse)  ## Conflictions is not matter