## Date : 2025-03-17
## Author : HollyRiver

## Chapter 3 - �����Ϳ� �ڷᱸ��

##----------3.3 Vector----------
### 1. generate Vector
v1 <- c(1,2,3,4,5) ## ������ ����
v2 <- c('a', 'b', 'c') ## ������ ����
v3 <- c(T, F, F) ## ���� ����
v4 <- c(1,2,3,'a','b','c') ## ���ڰ� ���ڰ� �� �� �����Ƿ�, �⺻������ ������ ����

#### sequence
v5 <- 1:10
v6 <- seq(1, 10, 2) ## 1���� 10���� ������ 2�� �ϴ� ����
v7 <- rep(1:5, 3) ## 1:5�� 3�� �ݺ�. �⺻������ times�� ����
v8 <- rep(1:5, each = 3) ## each elements�� n�� �ݺ�

seq(10) # ????? �� 10:1 �ƴ�
seq(length.out = 10) # �� �� ����Ʈ �հ� 1:10��
rep(1:5, 3, each = 3) ## 111222333444555111222333444555...

### 2. vector indexing
v <- c(6,8,1,9,7)
v[1] ## �ε����� 1���� ����;;
v[6] ## NA : Out of range error�� �ȶ߳�.

v[1:3] ## �����̽�
v[-5] ## �ڸ� �������� �ϴ� �� �ƴ϶�... �ش� �ε����� �����ϰ� ����
v[c(T, T, F, T, F)] ## TRUE�� �ش��ϴ� �ε��� �� ����

### 3. ���� �������
v9 <- c(3, 7, 8)
v10 <- c(4, 2, 8)

v9 + 2  ## ���� + ��Į�� �������? -> ��ǻ� ���� ������ ���� �� ����. ���Ͷ���¡
v9 + v10  ## ������ ũ�� ���� �� �������

v9 + c(10, 5)  ## warning. v9 + c(10, 5, 10)�� �����ϰ� ó����. ��Ȱ�� ��Ģ ���

#### ���Ϳ� ���밡���� �Լ�
sum(1:10)
mean(1:10)
median(1:10)
max(1:10)
min(1:10)
var(1:10)
sd(1:10)
length(1:10)

### 4. ���� �񱳿���
v11 <- 1:10
v11 >= 5  ## �� ��� ���ҿ� ���ؼ� �񱳿����ڸ� ����
v11[v11 >= 5] ## 5 �̻��� �� ����
## �� length(v11[v11 < 5]) ## �̷��� �Ⱦ��� ����
sum(v11 < 5) ## ������ ������꿡 ���Ǵ� ���. 5 �̸��� ���� ����
sum(v11[v11 < 5]) ## 5 �̸��� ���� �հ�. 1+2+3+4

### 5. factor
seasons <- c('spring', 'fall', "winter", "summer", "summer", "spring")
seasons_factor <- factor(seasons)
seasons_factor  ## ���ڿ��� ����ǥ�� ������ �ʰ�, factor�� ���� �� �ִ� ������ levels�� ǥ�õ�.

levels(seasons_factor)  ## levels�� ������ ���ͷ� ����. �⺻ ������ ������

seasons_factor[7] <- "autumn"
seasons_factor  ## �ϴ� ���� ��. <NA>�� ��.

table(seasons_factor) ## ��ǥ ����
barplot(table(seasons_factor))

#### ������ levels ���� ����
szn_fct2 <- factor(seasons, levels = c("spring", "summer", "fall", "winter"))
szn_fct2

table(szn_fct2)
barplot(table(szn_fct2))

##----------3.4 Matrix and Array----------
### 1. ��� ����
m1 <- matrix(1:20, nrow = 4, ncol = 5)
m1 ## �⺻������ ������ ä��

m1[1,]
m1[3, 3]

m2 <- matrix(1:20, nrow = 4, byrow = TRUE)
m2 ## ����� ä�� �� ����

matrix(1:20, nrow = 4, ncol = 3) ## ����� �ʹ� ������ �ڰ� ©��

#### ��/���� �̸� ���̱�...???
score <- matrix(c(80, 67, 74,
                  82, 95, 88,
                  75, 84, 82,
                  95, 83, 76),
                nrow = 4, byrow = TRUE) ## �̴�� ���� �Ϸ��� TRUE��...

dim(score)
nrow(score) ## dim(score)[1]
ncol(score) ## dim(score)[2]

rownames(score) ## NULL : ���ǵ��� ����
colnames(score)

rownames(score) <- c("Kim", "Lee", "Park", "Choi")
colnames(score) <- c("Kor", "Eng", "Math")

score ## ���� �̸��� ���� �̸��� �Ҵ��.

### 2. ��� �ε���
m <- matrix(1:15, nrow = 3)
m[2, 4] ## �ϳ��� ����
m[3,] ## �� ���� ����
m[, 1] ## �� ���� ����
m[c(1,3),] ## �����̽�. ���̽�� �޸� �׳� ���ͷ� ��� ������ ��.
m[,c(2,4,5)]


m[-2,] ## ��ģ ���. ���� ȣ���ϴ� ����. �ڿ������� ȣ�� ����.

#### �񱳿�����
v <- 1:5
v > 2 ## ������ ��� �� ���Ҹ��� ����

m > 7 ## ��ĵ� �� ���Ҹ��� ����

### 3. ��� �������
m2 <-  matrix(1:20, nrow = 4)
m3 <- matrix(21:40, nrow = 4)
m4 <- matrix(1:10, nrow = 5)
v1 <- c(1:4)

m2 + m3 ## ���� ����� �տ���� ����
m2 - m3 ## ���� ����� �տ���� ����
m2 * m3 ## ��İ��� �ٸ�, ���� ��ġ�� �ִ� �ֵ鳢�� ����
m2 / m3 ## ���� ��ġ�� �ִ� �ֵ鳢�� ����

m2 %*% m4 ## ��İ� : (4, 2) matrix

m2 + c(1:3) ## �� ������� �����ִµ�

### 4. Ư�����
diag(1, nrow = 3, ncol = 3)   ## �������
matrix(0, nrow = 3, ncol = 3) ## �����, ���� ���� ���ڶ� ������
diag(c(1,2,3))  ## �밢���. �������� �� 0���� ä����
matrix(c(1,2,2,1), nrow = 2)  ## ��Ī����� �׳� ������ �� ����

A <- matrix(1:6, nrow = 2)
t(A)  ## ��ġ���

B <- matrix(1:4, nrow = 2)
solve(B)  ## �����
det(B)    ## ��Ľ�

B %*% solve(B) ## ��������� ����. �� ������.

### 5. ��� ����
m4 <- matrix(1:12, nrow = 4)  ## 4*3
m5 <- matrix(13:18, nrow = 2) ## 2*3

m6 <- rbind(m4, m5)
## rbind(m5, m4)

## ��Ŀ� ���͵� ������ �� ���� : ���� ������ �����ϸ�
v <- 1:6
m7 <- cbind(m6, v)  ## �ش� ���� ���, ������ �������� �����Ǿ� �����Ƿ� ���̸�
colnames(m7)

colnames(m7) <- NULL
colnames(m7)

### 6. �迭
arr <- array(1:12, dim = c(2,2,3))
arr

##----------3.5 List----------
### 1. ����Ʈ ����
myinfo <- list(name = "Kim",
               age = 25,
               smoking = TRUE,
               score = c(70, 85, 90)
)

myinfo$name
myinfo$score[1]

### 2. ����Ʈ �ε���
is(myinfo[[2]]) ## ����Ʈ ���Ҹ� ȣ����. is�� �̿��Ͽ� Ÿ���� ��Ÿ�� �� ����
is(myinfo[2])   ## ����Ʈ �״�� ȣ����

myinfo$age      ## ���� �̷��� ��


##----------3.6 DataFrame----------
### 1. ������������ ����
df1 <- data.frame(name = c("Kim", "Lee", "Park", "Choi"),
                  age = c(24, 25, 22, 27),
                  btype = factor(c("A", 'B', 'O', 'B'), levels = c("A", "B", "AB", "O")),
                  smoking = c(T, F, T, T)
)

df1$btype

## ������ �߰�
# data.frame(df1,
#            pet = c("dog", "cat", "bird", "dog"))  ## �̷��� �ᵵ ��

df2 <- cbind(df1, c("dog", "cat", "bird", "dog"))

colnames(df2)[5] <- "pet"
df2

### 2. ������������ �ε��� : matrix�� ������ ���
## matrix������ ������ ��
df2[1, 2] ## 1�� 2���� ��ġ�� ��
df2[, 3]  ## 3���� ��ġ�� ��� ��
df2[4,]   ## 4�࿡ ��ġ�� ��� ��
df2[, "btype"]  ## btype ��(3��)�� ��ġ�� ��� ��
df2[, c("name", 'age')] ## �����ϰ� ���� ���� ���� ���� ���
df2[, 1:3]  ## �����̽�

## �����������ӿ����� �����Ѱ� : ����Ʈ�� Ư���� ���
df2$smoking
df2$age

### 3. ������������ ��� �Լ�
head(iris)  ## ���� 6�� ���� ����
tail(iris)  ## �ļ� 6�� ���� ����

dim(iris)   ## (150, 5) �������������� ����
nrow(iris)
ncol(iris)

str(iris)   ## �̰� ���� ���� head�� tail, dim�� ����� �ʿ䰡 ����.

unique(iris[5]) ## 5�� ǰ���� ����ũ �� �ľ�. ���ڿ��� ����Ǿ� ���� ��� ����
table(iris["Species"]) ## �� ����ũ �� ���� �� ���� ������ �ִ���.

colMeans(iris)  ## �ȵ�. ��� ��ġ���� �־�� ��.
colMeans(iris[-5])
colMeans(iris[, -5])
colSums(iris[-5])

rowMeans(iris[, -5])  ## -> ���ִ� �Ⱦ� ����
rowSums(iris[, -5])