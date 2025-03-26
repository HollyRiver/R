### Date : 2025-03-24
### Author : Hollyriver
### Title : 4. Programming Architecture

##----------2. Conditional Statement----------
### 1. if��
## ex) ���� ������ 80�� �̻��̸� �հ� ���
score <- 85

if (score >= 80) {
  print("Pass")
}

## �����ϰ� ���� �� �� ���̸�...
if (score >= 80) print("Pass")

### 2. if-else��
score <- 75

if (score >= 80) {
  print("Pass")
} else {
  print("Fail")
}

if (score >= 80) print("Pass") else print("Fail") ## �̷��� �ǳ�

## �鿩���� �������� �س��� ���ư�
if (score >= 80) {
    print("Pass")
      } else {
  print("Fail")
}

### 3. ifelse() �Լ�
score <- 85
result <- ifelse(score >= 80, "Pass", "Fail") ## ifelse(bool, arg_T, arg_F)
print(result)

### 4. else if��
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
### 1. for ��
#### *�� 5�� ���
for (�ݺ����� in 1:5) {
  print("*")
}

#### ������ 2���� ���
for (i in 1:9) {
  print(cat("2 ��", i, "=", 2*i))  ## �̷��� ���ϱ� �ڿ� NULL�� ����;;
}

output <- ""

for (i in 1:9) {
  output <- cat(output, "2 ��", i, "=", 2*i, "\n")
}

## �̰͵� �ȵǳ�. ������. �׳� cat�� ����Ʈ�� ���ִ� ���ε�


#### 1~20 ������ ���� �� ¦���� ���
for (i in 1:20) {
  if (i %% 2 == 0) {
    print(i)
  }
}

#### 1~n��° ���ұ����� ���� ��� -> ���������� ��
sum <- 0
n <- 100

for (i in 1:n) {
  sum <- sum + i
}

print(sum)  ## �������� �հ��� ������

### 2. while ��
#### 1~100 ������ ���ڸ� �հ� ���
sum <- 0
i <- 1

while (i <= 100) {
  sum <- sum + i
  i <- i + 1
}

print(sum)

#### ���ѷ��� : �ϸ� �ȵ�

### 3. break���� next��
## 1���� 100���� ���ϱ� : while�� ����
sum <- 0
i <- 1

while (TRUE) {
  sum <- sum + i
  i <- i + 1
  
  if (i > 100) {
    break
  }
}

## 1~10 ������ ���� �߿��� Ȧ���� �հ�
sum <- 0

for (i in 1:10) {
  if (i%%2 == 0) {
    next
  }
  sum <- sum + i
}

## �� �ǽ��� ���� ���ϻ�, �ſ� ȿ�뼺 ���� �ڵ���. �׳� ��, ��.