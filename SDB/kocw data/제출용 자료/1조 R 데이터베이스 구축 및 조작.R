library(DBI)
library(RSQLite)
library(readxl)

professor_data <- read_excel("C:/Users/leesj/Downloads/professor (2).xlsx")
course_classed_data <- read_excel("C:/Users/leesj/Downloads/course_classed (2).xlsx")
norm_course_data <- read_excel("C:/Users/leesj/Downloads/norm_course (3).xlsx")
charge_data <- read_excel("C:/Users/leesj/Downloads/charge (3).xlsx")
university_data <- read_excel("C:/Users/leesj/Downloads/university (3).xlsx")

professor_data <- professor_data[,-1]
course_classed_data <- course_classed_data[,-1]
norm_course_data <- norm_course_data[,-1]
charge_data <- charge_data[,-1]
university_data <- university_data[,-1]

names(university_data)[names(university_data) == "대학소재지(시/도)"] <- "대학소재지"
names(university_data)[names(university_data) == "사립/국립 구분"] <- "구분"

conn <- dbConnect(RSQLite::SQLite(), "kocw.db")

dbExecute(conn, "PRAGMA foreign_keys = ON")
dbExecute(conn, "DROP TABLE IF EXISTS charge")
dbExecute(conn, "DROP TABLE IF EXISTS norm_course")
dbExecute(conn, "DROP TABLE IF EXISTS course_classed")
dbExecute(conn, "DROP TABLE IF EXISTS professor")
dbExecute(conn, "DROP TABLE IF EXISTS university")

dbExecute(conn, "
CREATE TABLE university (
  제공대학명 TEXT PRIMARY KEY,
  대학소재지 TEXT,
  구분 TEXT
)")

dbExecute(conn, "
CREATE TABLE norm_course (
  강의코드 INTEGER PRIMARY KEY,
  강의명 TEXT,
  강의년도 INTEGER,
  강의학기 INTEGER,
  제공일자 DATE,
  제공대학명 TEXT,
  FOREIGN KEY (제공대학명) 
  REFERENCES university(제공대학명)
  ON UPDATE CASCADE
  ON DELETE SET NUll,
  FOREIGN KEY (강의명)
  REFERENCES course_classed(강의명)
  ON UPDATE CASCADE
  ON DELETE CASCADE
)")

dbExecute(conn, "
CREATE TABLE professor (
  교수코드 INTEGER PRIMARY KEY,
  담당교수명 TEXT,
  담당분야 TEXT,
  제공대학명 TEXT,
  FOREIGN KEY (제공대학명)
  REFERENCES university(제공대학명)
  ON UPDATE CASCADE
  ON DELETE SET NUll
)")

dbExecute(conn, "
CREATE TABLE charge (
  교수코드 INTEGER,
  강의코드 INTEGER,
  FOREIGN KEY (교수코드)
  REFERENCES professor(교수코드)
  ON UPDATE CASCADE
  ON DELETE CASCADE
  FOREIGN KEY (강의코드)
  REFERENCES norm_course(강의코드)
  ON UPDATE CASCADE
  ON DELETE CASCADE
  PRIMARY KEY (교수코드, 강의코드)
)")



dbExecute(conn, "
CREATE TABLE course_classed (
  강의명 TEXT PRIMARY KEY,
  교육분류 TEXT
)")



dbWriteTable(conn, "university", university_data, append = TRUE, row.names = FALSE)
dbWriteTable(conn, "professor", professor_data, append = TRUE, row.names = FALSE)
dbWriteTable(conn, "course_classed", course_classed_data, append = TRUE, row.names = FALSE)
dbWriteTable(conn, "norm_course", norm_course_data, append = TRUE, row.names = FALSE)
dbWriteTable(conn, "charge", charge_data, append = TRUE, row.names = FALSE)


dbListTables(conn)

#1.기본키설정이 맞는지 확인 + 튜플의 수정 및 삭제

## professor 중복되지 않는 기본키를 가지는 튜플 삽입 시 정상
dbExecute(conn, "INSERT INTO professor VALUES(-1, '강신성', '자연계열', '전북대학교')")
dbGetQuery(conn, "SELECT * FROM professor LIMIT 5")

## 수정
dbExecute(conn, "UPDATE professor SET 제공대학명 = '조선대학교' WHERE 교수코드 = -1")
dbGetQuery(conn, "SELECT * FROM professor LIMIT 5")

## 삭제
dbExecute(conn, "DELETE FROM professor WHERE 교수코드 = -1")
dbGetQuery(conn, "SELECT * FROM professor LIMIT 5")

## 중복되는 기본키를 가지는 튜플 삽입 시 오류 발생 -> 정상적으로 기본키 설정됨
dbExecute(conn, "INSERT INTO professor VALUES(1, '강신성2', '자연계열', '전북대학교')")



## university 중복되지 않는 기본키를 가지는 튜플 삽입 시 정상
dbExecute(conn, "INSERT INTO university VALUES('1조대학교', '뉴욕', '사립')")
dbGetQuery(conn, "SELECT * FROM university LIMIT 10 OFFSET 182")

## 수정
dbExecute(conn, "UPDATE university SET 대학소재지 = '도쿄' WHERE 제공대학명 = '1조대학교'")
dbGetQuery(conn, "SELECT * FROM university LIMIT 10 OFFSET 182")

## 삭제
dbExecute(conn, "DELETE FROM university WHERE 제공대학명 = '1조대학교'")
dbGetQuery(conn, "SELECT * FROM university LIMIT 10 OFFSET 182")

## 중복되는 기본키를 가지는 튜플 삽입 시 오류 발생 -> 정상적으로 기본키 설정됨
dbExecute(conn, "INSERT INTO university VALUES('전북대학교', '뉴욕', '국립')")


## norm_course 중복되지 않는 기본키를 가지는 튜플 삽입 시 정상
dbExecute(conn, "INSERT INTO norm_course VALUES(-1, '윤리학개론', '2025', '3', '2025-09-09', '연세대학교')")
dbGetQuery(conn, "SELECT * FROM norm_course LIMIT 5")

## 수정
dbExecute(conn, "UPDATE norm_course SET 강의명 = '수학1' WHERE 강의코드 = -1")
dbGetQuery(conn, "SELECT * FROM norm_course LIMIT 5")

## 삭제
dbExecute(conn, "DELETE FROM norm_course WHERE 강의코드 = -1")
dbGetQuery(conn, "SELECT * FROM norm_course LIMIT 5")

## 중복되는 기본키를 가지는 튜플 삽입 시 오류 발생 -> 정상적으로 기본키 설정됨
dbExecute(conn, "INSERT INTO norm_course VALUES(127521, '수학1', '2025', '3', '2025-09-09', '연세대학교')")


## course_classed 중복되지 않는 기본키를 가지는 튜플 삽입 시 정상
dbExecute(conn, "INSERT INTO course_classed VALUES('가수업', '가분류')")
dbGetQuery(conn, "SELECT * FROM course_classed ORDER BY rowid DESC LIMIT 5")

## 수정
dbExecute(conn, "UPDATE course_classed SET 교육분류 = '나분류' WHERE 강의명 = '가수업'")
dbGetQuery(conn, "SELECT * FROM course_classed ORDER BY rowid DESC LIMIT 5")


## 삭제
dbExecute(conn, "DELETE FROM course_classed WHERE 강의명 = '가수업'")
dbGetQuery(conn, "SELECT * FROM course_classed ORDER BY rowid DESC LIMIT 5")


## 중복되는 기본키를 가지는 튜플 삽입 시 오류 발생 -> 정상적으로 기본키 설정됨
dbExecute(conn, "INSERT INTO course_classed VALUES('과학사 이해', '다분류')")


## charge 중복되지 않는 기본키를 가지는 튜플 삽입 시 정상
dbExecute(conn, "INSERT INTO charge VALUES(1, 1112400)")
dbGetQuery(conn, "SELECT * FROM charge ORDER BY rowid DESC LIMIT 5")

## 삭제
dbExecute(conn, "DELETE FROM charge WHERE 교수코드= 1 AND 강의코드= 111240")
dbGetQuery(conn, "SELECT * FROM charge ORDER BY rowid DESC LIMIT 5")

## charge 중복되는 기본키를 가지는 튜플 삽입 시 오류 발생 -> 정상적으로 기본키 설정됨
dbExecute(conn, "INSERT INTO charge VALUES(1, 1104074)")



#2기본키 삭제에 따른 외래키 변화 확인

#기본키 수정
dbExecute(conn, "UPDATE university SET 제공대학명 = '전북특별자치대학교' WHERE 제공대학명 = '전북대학교'")
dbGetQuery(conn, "SELECT * FROM university WHERE 제공대학명 = '전북특별자치대학교'")
dbGetQuery(conn, "SELECT * FROM norm_course WHERE 제공대학명 = '전북특별자치대학교' LIMIT 5")
#원래대로 복구
dbExecute(conn, "UPDATE university SET 제공대학명 = '전북대학교' WHERE 제공대학명 = '전북특별자치대학교'")


#기본키 삭제(ON DELETE SET NUll)
dbExecute(conn, "DELETE FROM university WHERE 제공대학명 = '전북대학교'")
dbGetQuery(conn, "SELECT * FROM norm_course WHERE 제공대학명 IS NULL LIMIT 5")
dbGetQuery(conn, "SELECT * FROM professor WHERE 제공대학명 IS NULL LIMIT 5")

#기본키 삭제(ON DELETE CASCADE)
dbGetQuery(conn, "SELECT * FROM norm_course WHERE 강의명 = '수학1'")
dbExecute(conn, "DELETE FROM course_classed WHERE 강의명 = '수학1'")
dbGetQuery(conn, "SELECT * FROM norm_course WHERE 강의명 = '수학1'")

#3 조인 조작의 정상성 여부 확인
#조인을 이용해 쪼개기 전 테이블 만들기

#제공대학명을 기준으로 교수와 제공대학을 내부 조인
dbGetQuery(conn, "SELECT * FROM professor LIMIT 6")
dbGetQuery(conn, "SELECT * FROM university LIMIT 6")
dbGetQuery(conn, "SELECT 교수코드, 담당교수명, 담당분야, university.제공대학명 AS 제공대학명, 대학소재지, 구분
           FROM university INNER JOIN professor ON university.제공대학명 = professor.제공대학명 LIMIT 6")

#위 테이블과 담당을 조인
dbGetQuery(conn, "SELECT * FROM charge LIMIT 6")
dbGetQuery(conn, "SELECT 강의코드,
           professor.교수코드 AS 교수코드, 담당교수명, 담당분야,
           university.제공대학명 AS 제공대학명, 대학소재지, 구분
           FROM university INNER JOIN professor ON university.제공대학명 = professor.제공대학명
           INNER JOIN charge ON professor.교수코드 = charge.교수코드 LIMIT 6")

#위 테이블과 강의를 조인
dbGetQuery(conn, "SELECT * FROM norm_course LIMIT 6")
dbGetQuery(conn, "SELECT norm_course.강의코드 AS 강의코드, 강의명, 강의년도, 강의학기, 제공일자,
           professor.교수코드 AS 교수코드, 담당교수명, 담당분야,
           university.제공대학명 AS 제공대학명, 대학소재지, 구분
           FROM university INNER JOIN professor ON university.제공대학명 = professor.제공대학명
           INNER JOIN charge ON professor.교수코드 = charge.교수코드
           INNER JOIN norm_course ON charge.강의코드 = norm_course.강의코드 LIMIT 6")

#위 테이블과 강의교육분류를 내부 조인
dbGetQuery(conn, "SELECT * FROM course_classed LIMIT 6")
dbGetQuery(conn, "SELECT norm_course.강의코드 AS 강의코드, 강의년도, 강의학기, 제공일자,
           course_classed.강의명 AS 강의명, 교육분류,
           professor.교수코드 AS 교수코드, 담당교수명, 담당분야,
           university.제공대학명 AS 제공대학명, 대학소재지, 구분
           FROM university INNER JOIN professor ON university.제공대학명 = professor.제공대학명
           INNER JOIN charge ON professor.교수코드 = charge.교수코드
           INNER JOIN norm_course ON charge.강의코드 = norm_course.강의코드
           INNER JOIN course_classed ON norm_course.강의명 = course_classed.강의명 LIMIT 6")

#4정보추출을 위한 주요 변수 및 목표 서술
#지역, 대학구분에 따라 제공되는 강의 수의 차이를 파악 (R)

#지역별 강의 수
dbGetQuery(conn, "SELECT count(강의코드) AS 강의수, 대학소재지
           FROM norm_course INNER JOIN university ON norm_course.제공대학명 = university.제공대학명
           GROUP BY 대학소재지 ORDER BY 강의수 DESC")

df_domain <- dbGetQuery(conn, "SELECT count(강의코드) AS 강의수, 대학소재지
           FROM norm_course INNER JOIN university ON norm_course.제공대학명 = university.제공대학명
           GROUP BY 대학소재지 ORDER BY 강의수 DESC")

library(ggplot2)
options(repr.plot.width = 10)
df_domain$대학소재지 = factor(df_domain$대학소재지, levels = as.array(df_domain$대학소재지))

ggplot(df_domain, aes(대학소재지, 강의수)) +
  geom_bar(stat = 'identity', fill = "steelblue") +
  labs(title = "대학 소재지별 강의 수", x = "대학 소재지", y = "강의 수") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1, size = 10))

#지역별 대학의 강의 수 평균
dbGetQuery(conn, "SELECT 대학소재지, AVG(강의수) AS 평균강의수
    FROM (SELECT 제공대학명, COUNT(강의코드) AS 강의수
    FROM norm_course
    GROUP BY 제공대학명) AS 대학강의수
    INNER JOIN university ON 대학강의수.제공대학명 = university.제공대학명
    GROUP BY 대학소재지")


#대학구분에 따른 강의 수
dbGetQuery(conn, "SELECT count(강의코드) AS 강의수, 구분
           FROM norm_course INNER JOIN university ON norm_course.제공대학명 = university.제공대학명
           GROUP BY 구분 ORDER BY 강의수 DESC")


df_domain2 <- dbGetQuery(conn, "SELECT count(강의코드) AS 강의수, 구분
           FROM norm_course INNER JOIN university ON norm_course.제공대학명 = university.제공대학명
           GROUP BY 구분 ORDER BY 강의수 DESC")
options(repr.plot.width = 7)

ggplot(df_domain2, aes(구분, 강의수)) +
  geom_bar(stat = 'identity', fill = c("skyblue", "orange")) +
  labs(title = "구분별 강의 수", x = "구분", y = "강의 수") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))






dbDisconnect(conn)

