library(DBI)
library(RSQLite)

#################################################################################
#################################################################################
## 개 괄

data("mtcars")
mtcars$car_names <- rownames(mtcars)
rownames(mtcars) <- c()
head(mtcars)

conn <- dbConnect(RSQLite::SQLite(), "CarsDB.db")

dbWriteTable(conn, "cars_data", mtcars)
dbListTables(conn)

car <- c('Camaro', 'California', 'Mustang', 'Explorer')
make <- c('Chevrolet','Ferrari','Ford','Ford')
df1 <- data.frame(car,make)
car <- c('Corolla', 'Lancer', 'Sportage', 'XE')
make <- c('Toyota','Mitsubishi','Kia','Jaguar')
df2 <- data.frame(car,make)

dfList <- list(df1,df2)
for(k in 1:length(dfList)){
  dbWriteTable(conn,"Cars_and_Makes", dfList[[k]], append = TRUE)
}

dbListTables(conn)

dbGetQuery(conn, "SELECT * FROM Cars_and_Makes")
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 20")
dbGetQuery(conn, "SELECT car_names, hp, cyl FROM cars_data
                  WHERE cyl = 8")

dbGetQuery(conn,"SELECT cyl, AVG(hp) AS 'average_hp', AVG(mpg) AS 'average_mpg' FROM cars_data
                 GROUP BY cyl
                 ORDER BY average_hp")

avg_HpCyl <- dbGetQuery(conn,"SELECT cyl, AVG(hp) AS 'average_hp'FROM cars_data
                 GROUP BY cyl
                 ORDER BY average_hp")

avg_HpCyl
class(avg_HpCyl)

mpg <-  18
cyl <- 6
Result <- dbGetQuery(conn, 'SELECT car_names, mpg, cyl FROM cars_data WHERE mpg >= ? AND cyl >= ?', params = c(mpg,cyl))
Result

assembleQuery <- function(conn, base, search_parameters){
  parameter_names <- names(search_parameters)
  partial_queries <- ""
  for(k in 1:length(parameter_names)){
    filter_k <- paste(parameter_names[k], " >= ? ")
    if(k > 1){
      filter_k <- paste("AND ", parameter_names[k], " >= ?")
    }
    partial_queries <- paste(partial_queries, filter_k)
  }
  final_paste <- paste(base, " WHERE", partial_queries)

  print(final_paste)
  values <- unlist(search_parameters, use.names = FALSE)
  
  result <- dbGetQuery(conn, final_paste, params = values)
  return(result)
}

base <- "SELECT car_names, mpg, hp, wt FROM cars_data"
search_parameters <- list("mpg" = 16, "hp" = 150, "wt" = 2.1)
result <- assembleQuery(conn, base, search_parameters)
result

dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")
dbExecute(conn, "DELETE FROM cars_data WHERE car_names = 'Mazda RX4'")
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")

dbExecute(conn, "INSERT INTO cars_data VALUES (21.0,6,160.0,110,3.90,2.620,16.46,0,1,4,4,'Mazda RX4')")
dbGetQuery(conn, "SELECT * FROM cars_data")

dbDisconnect(conn)

#################################################################################
#################################################################################
## 데이블 구성 및 조작

conn <- dbConnect(RSQLite::SQLite(), ".temp.db")
dbRemoveTable(conn, "iris_db")

# s <- sprintf("create table %s(%s, primary key(%s))", "DF",
#             paste(names(DF), collapse = ", "),
#             names(DF)[6])

dbSendQuery(conn, "CREATE TABLE iris_db (
            Sepal_Length REAL,     Sepal_Width REAL, 
            Petal_Length REAL,     Petal_Width TEXT NOT NULL, 
            Species TEXT
            )")

data(iris)
colnames(iris) = c('Sepal_Length', 'Sepal_Width', 
                   'Petal_Length', 'Petal_Width', 
                   'Species')

#iris[,4] = NA
dbWriteTable(conn, "iris_db", iris, append=TRUE, row.names=FALSE)
dbGetQuery(conn, "SELECT * FROM sqlite_schema WHERE name = 'iris_db'")

dbGetQuery(conn, "SELECT * FROM iris_db") -> v 


dbSendQuery(conn, "INSERT INTO iris_db
                  (Sepal_length, Sepal_width, Petal_length, Petal_width, Species)
                  VALUES
                  (5.1, 3.5, 1.4, 0.2, 'setosa'),
                  (5.1, 3.3, 1.5, 0.2, 'setosa')" )

dbSendQuery(conn, "INSERT INTO iris_db
                  (Sepal_length, Sepal_width, Petal_length, Petal_width, Species)
                  VALUES
                  (5.2, 3.5, 1.4, 0.3, 'setosa')")

dbExecute(conn, "DELETE FROM iris_db WHERE Species = 'virginica'")
dbGetQuery(conn, "SELECT * FROM iris_db")

dbSendQuery(conn, "UPDATE iris_db SET Species = 'ss' WHERE Species = 'setosa' ") 
dbGetQuery(conn, "SELECT * FROM iris_db")

dbDisconnect(conn)

#################################################################################
#################################################################################

dbExecute(conn, "
CREATE TABLE mytable
(
  a INTEGER PRIMARY KEY, 
  b TEXT
)")
dbExecute(conn,"insert into mytable values(1,'test')")
dbExecute(conn,"insert into mytable values(2,'test')")
dbExecute(conn,"insert into mytable values(6,'test')")

dbSendQuery(conn, "CREATE TABLE iris_db (
            Sepal_Length REAL,
            Sepal_Width REAL, 
            Petal_Length REAL, 
            Petal_Width REAL, 
            Species TEXT PRIMARY KEY 
            )")

dbSendQuery(conn, "INSERT INTO iris_db
                  (Sepal_length, Sepal_width, Petal_length, Petal_width, Species)
                  VALUES
                  (5.1, 3.5, 1.4, 0.2, 'setosa')")
dbGetQuery(conn, "SELECT * FROM iris_db")

dbWriteTable(conn, "iris_db", iris, append=TRUE, row.names=FALSE)

dbRemoveTable(conn, "iris_db")
dbRemoveTable(conn, "mytable")

dbRemoveTable(conn, "suppliers")
dbRemoveTable(conn, "supplier_groups")

##################################################################################

dbListTables(conn)

dbSendQuery(conn, "CREATE TABLE iris_db 
(Sepal_Length REAL,   Sepal_Width REAL,   
Petal_Length REAL,   Petal_Width REAL,             
Species TEXT PRIMARY KEY)")

dbSendQuery(conn, "INSERT INTO iris_db                  
(Sepal_length, Sepal_width, Petal_length, 
Petal_width, Species) VALUES                  
(5.1, 3.5, 1.4, 0.2, 'setosa')")

dbGetQuery(conn, "SELECT * FROM iris_db")

##

dbListTables(conn)
dbExecute(conn, "PRAGMA foreign_keys = ON")

dbExecute(conn, "CREATE TABLE supplier_groups 
(group_id integer PRIMARY KEY, group_name text NOT NULL)")

dbRemoveTable(conn, "suppliers")
dbExecute(conn, "CREATE TABLE suppliers 
(supplier_id   INTEGER PRIMARY KEY,  
 supplier_name TEXT   NOT NULL,  
 group_id      INTEGER,  
FOREIGN KEY (group_id)  
REFERENCES supplier_groups (group_id)
ON UPDATE SET NULL  
ON DELETE SET NULL)")


dbSendQuery(conn, "INSERT INTO supplier_groups (group_name)
VALUES
('Domestic'),
('Global'),
('One-Time')" ) 

dbSendQuery(conn, "INSERT INTO suppliers (supplier_name, group_id)
VALUES ('HP', 2)" )
dbSendQuery(conn, "INSERT INTO suppliers (supplier_name, group_id)
VALUES('ABC Inc.', 3)") 


dbGetQuery(conn, "SELECT * FROM supplier_groups")
dbGetQuery(conn, "SELECT * FROM suppliers")

dbExecute(conn, "DELETE FROM supplier_groups WHERE group_id = 3")
dbGetQuery(conn, "SELECT * FROM supplier_groups")
dbGetQuery(conn, "SELECT * FROM suppliers")

dbRemoveTable(conn, "suppliers")
dbRemoveTable(conn, "supplier_groups")

dbExecute(conn, "CREATE TABLE supplier_groups (
  group_id integer PRIMARY KEY,
  group_name text NOT NULL
)")

dbExecute(conn, "PRAGMA foreign_keys = ON")

dbExecute(conn, "CREATE TABLE suppliers (
  supplier_id   INTEGER PRIMARY KEY,
  supplier_name TEXT   ,
  group_id      INTEGER,
  FOREIGN KEY (group_id)
  REFERENCES supplier_groups (group_id)
  ON UPDATE CASCADE
  ON DELETE CASCADE
)")

dbSendQuery(conn, "INSERT INTO supplier_groups (group_name)
VALUES
('Domestic'),
('Global'),
('One-Time')" )

dbExecute(conn,"INSERT INTO suppliers (supplier_name, group_id)
VALUES('XYZ Corp', 1)")
dbExecute(conn, "INSERT INTO suppliers (supplier_name, group_id)
VALUES('ABC Corp', 2)")


dbExecute(conn, "UPDATE supplier_groups
SET group_id = 100
WHERE group_name = 'Domestic'")

dbGetQuery(conn, "SELECT * FROM suppliers" )
dbGetQuery(conn, "SELECT * FROM supplier_groups" )

dbExecute(conn, "DELETE FROM supplier_groups 
WHERE group_id = 2")
dbGetQuery(conn, "SELECT * FROM suppliers")

##
# 스키마 확인 ##

dbGetQuery(conn, "SELECT * FROM sqlite_schema WHERE name = 'suppliers'")

dbRemoveTable(conn, "supplier_groups")

dbExecute(conn, "CREATE TABLE supplier_groups (
  group_id INTEGER PRIMARY KEY CHECK(GROUP_iD<=100),
  group_name TEXT NOT NULL,
  date_time DEFAULT CURRENT_TIMESTAMP, 
  id INTEGER DEFAULT 0, 
  iden INTEGER UNIQUE
)")


dbSendQuery(conn, "INSERT INTO supplier_groups (group_id, group_name, iden)
VALUES
(1,'Domestic',1),
(2,'Global',2),
(8, 'One-Time',3)" )

dbGetQuery(conn, "SELECT * FROM supplier_groups")

dbRemoveTable(conn, "suppliers")
dbRemoveTable(conn, "supplier_groups")

dbExecute(conn, "CREATE TABLE supplier_groups (
  group_id INTEGER CHECK(GROUP_iD<=100),
  group_name TEXT NOT NULL,
  date_time DEFAULT CURRENT_TIMESTAMP, 
  id INTEGER DEFAULT 0, 
  iden INTEGER UNIQUE, 
  PRIMARY KEY (group_id, iden))" )

dbSendQuery(conn, "INSERT INTO supplier_groups (group_id, group_name, iden)
VALUES
(1,'Domestic',1),
(2,'Global',2),
(8, 'One-Time',3)" )

dbGetQuery(conn, "SELECT * FROM supplier_groups")
dbGetQuery(conn, "SELECT * FROM sqlite_schema WHERE name = 'supplier_groups'")

dbDisconnect(conn)

##################

conn <- dbConnect(RSQLite::SQLite(), ".temp2.db")

dbExecute(conn, "CREATE TABLE supplier_groups (
  group_id INTEGER PRIMARY KEY CHECK(GROUP_iD<=100),
  group_name TEXT NOT NULL,
  idx INTEGER UNIQUE
)")

dbSendQuery(conn, "INSERT INTO supplier_groups (group_id, group_name, idx)
VALUES
(1,'Domestic',100),
(2,'Global',203),
(8,'One-Time',210)" )

dbExecute(conn, "CREATE TABLE demand_groups (
  group_id INTEGER PRIMARY KEY CHECK(GROUP_iD<=100),
  dgroup_name TEXT NOT NULL,
  idy INTEGER UNIQUE
)")

dbSendQuery(conn, "INSERT INTO demand_groups (group_id, dgroup_name, idy)
VALUES
(1,'Domestic',120),
(2,'Global',250),
(10,'Foreign',400)" )

dbGetQuery(conn, "SELECT * FROM supplier_groups")
dbGetQuery(conn, "SELECT * FROM demand_groups")

dbGetQuery(conn, "SELECT  *          
          FROM demand_groups 
          INNER JOIN supplier_groups ON 
          supplier_groups.group_id = demand_groups.group_id" )

dbGetQuery(conn, "SELECT dgroup_name, idy,
          demand_groups.group_id AS d_id,
          supplier_groups.group_id AS s_id 
          FROM demand_groups 
          INNER JOIN supplier_groups ON 
          supplier_groups.group_id = demand_groups.group_id" )

dbGetQuery(conn, "SELECT dgroup_name, idy,
          demand_groups.group_id AS d_id,
          supplier_groups.group_id AS s_id 
          FROM demand_groups 
          FULL OUTER JOIN supplier_groups ON 
          supplier_groups.group_id = demand_groups.group_id" )

dbGetQuery(conn, "SELECT dgroup_name, idy,
          demand_groups.group_id AS d_id,
          supplier_groups.group_id AS s_id 
          FROM demand_groups 
          LEFT OUTER JOIN supplier_groups ON 
          supplier_groups.group_id = demand_groups.group_id" )

dbGetQuery(conn, "SELECT dgroup_name, idy,
          demand_groups.group_id AS d_id,
          supplier_groups.group_id AS s_id 
          FROM demand_groups 
          RIGHT OUTER JOIN supplier_groups ON 
          supplier_groups.group_id = demand_groups.group_id" )

## Cartesian Product ## 

rs = dbGetQuery(conn, "SELECT  *          
          FROM demand_groups 
          CROSS JOIN supplier_groups")

dbGetQuery(conn, "SELECT * FROM sqlite_schema 
           WHERE name = 'rs'")

## Table 3 JOIN ## 


dbExecute(conn, "CREATE TABLE custom_groups (
  group_id INTEGER PRIMARY KEY CHECK(GROUP_iD<=100),
  cgroup_name TEXT NOT NULL,
  idz INTEGER UNIQUE
)")

dbSendQuery(conn, "INSERT INTO custom_groups (group_id, cgroup_name, idz)
VALUES
(1,'Domestic',11),
(2,'Global',22),
(10,'Foreign',42)" )

dbGetQuery(conn, "SELECT * FROM custom_groups")
