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