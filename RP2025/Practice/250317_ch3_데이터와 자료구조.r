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
