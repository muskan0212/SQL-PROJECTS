CREATE DATABASE ZOMATO;
USE ZOMATO;

CREATE TABLE ZOMATO_DATA
(Restaurant_ID INT,
Restaurant_Name VARCHAR(200),
CountryCode INT,
City VARCHAR(100),
Address VARCHAR(250),
Locality VARCHAR(250),
Locality_Verbose VARCHAR(800),
Longitude decimal(20,6),
Latitude decimal(20,5),
Cuisines VARCHAR(255),
Currency varchar(50),
Has_Table_booking VARCHAR(20),
Has_Online_delivery VARCHAR(20),
Is_delivering_now VARCHAR(20),
Switch_to_order_menu VARCHAR(20),
Price_range INT,
Votes INT,
Average_Cost_for_two INT,
Rating int,
Datekey_Opening DATE,
Cuisines_1 VARCHAR(30),
Cuisines_2 VARCHAR(30),
Cuisines_3 VARCHAR(30),
Cuisines_4 VARCHAR(30) ,
Cuisines_5 VARCHAR(30) ,
Cuisines_6 VARCHAR(30) ,
Cuisines_7 VARCHAR(30) ,
Cuisines_8 VARCHAR(30));

drop table zomato_data;

LOAD DATA INFILE
'E:/zomato1.csv'
into table ZOMATO_DATA
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE COUNTRY_DATA(
COUNTRY_ID INT,
COUNTRY_NAME VARCHAR(30));

drop table country_data;

LOAD DATA INFILE
'E:/zomato.data.csv'
into table COUNTRY_DATA
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ZOMATO_DATA;
SELECT * FROM COUNTRY_DATA;

##3.Find the Numbers of Resturants based on City and Country.

SELECT COUNT(ZOMATO_DATA.RESTAURANT_NAME) AS NO_OF_RESTAURANT, ZOMATO_DATA.RESTAURANT_NAME, 
ZOMATO_DATA.CITY, COUNTRY_DATA.COUNTRY_NAME FROM ZOMATO_DATA INNER JOIN  COUNTRY_DATA ON 
ZOMATO_DATA.COUNTRYCODE = COUNTRY_DATA.COUNTRY_ID GROUP BY
ZOMATO_DATA.CITY , ZOMATO_DATA.RESTAURANT_NAME, COUNTRY_DATA.COUNTRY_NAME ORDER BY NO_OF_RESTAURANT;

##4.Numbers of Resturants opening based on Year , Quarter , Month.

ALTER TABLE ZOMATO_DATA
ADD COLUMN `YEAR` YEAR AFTER DATEKEY_OPENING;
UPDATE ZOMATO_DATA SET `YEAR` = YEAR(DATEKEY_OPENING);

ALTER TABLE ZOMATO_DATA
ADD COLUMN `QUARTER` INT AFTER DATEKEY_OPENING;
UPDATE ZOMATO_DATA SET `QUARTER` = QUARTER(DATEKEY_OPENING);

ALTER TABLE ZOMATO_DATA
ADD COLUMN `MONTH` INT AFTER `YEAR`;
UPDATE ZOMATO_DATA SET `MONTH` = MONTH(DATEKEY_OPENING);

SELECT COUNT(RESTAURANT_NAME) AS NUMBER_OF_RESTAURANTS,`YEAR`, `QUARTER`, `MONTH` FROM ZOMATO_DATA 
GROUP BY `YEAR`, `QUARTER`, `MONTH` ORDER BY NUMBER_OF_RESTAURANTS;

SELECT distinct(RESTAURANT_ID), RESTAURANT_NAME, DATEKEY_OPENING FROM ZOMATO_DATA 
ORDER BY DATEKEY_OPENING asc;

##5.Count of Resturants based on Average Ratings. 

SELECT distinct( COUNT(RESTAURANT_ID)) AS AVRG, RESTAURANT_NAME, RATING FROM ZOMATO_DATA
WHERE RATING = (SELECT AVG(RATING) FROM ZOMATO_DATA) GROUP BY RESTAURANT_ID ORDER BY RESTAURANT_NAME;

##6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets ##

SELECT
CASE
WHEN AVERAGE_COST_FOR_TWO >= 0 AND AVERAGE_COST_FOR_TWO < 500 THEN "CHEAP"
WHEN AVERAGE_COST_FOR_TWO >= 500 AND AVERAGE_COST_FOR_TWO < 2000 THEN "SUPER AFFORDABLE"
WHEN AVERAGE_COST_FOR_TWO >= 2000 AND AVERAGE_COST_FOR_TWO < 10000 THEN "AFFORDABLE"
WHEN AVERAGE_COST_FOR_TWO >= 10000 AND AVERAGE_COST_FOR_TWO < 50000 THEN "LESS AFFORDABLE"
WHEN AVERAGE_COST_FOR_TWO >= 50000 AND AVERAGE_COST_FOR_TWO < 100000 THEN 'EXPENSIVE'
WHEN AVERAGE_COST_FOR_TWO >= 100000 THEN "LUXURIOUS"
ELSE 'NOT'
END AS REASONABLESIZE,
MIN(AVERAGE_COST_FOR_TWO) AS MINIMUM_AVG,
MAX(AVERAGE_COST_FOR_TWO) AS MAXIMUM_AVG
FROM ZOMATO_DATA
GROUP BY
CASE
WHEN AVERAGE_COST_FOR_TWO >= 0 AND AVERAGE_COST_FOR_TWO < 500 THEN "CHEAP"
WHEN AVERAGE_COST_FOR_TWO >= 500 AND AVERAGE_COST_FOR_TWO < 2000 THEN "SUPER AFFORDABLE"
WHEN AVERAGE_COST_FOR_TWO >= 2000 AND AVERAGE_COST_FOR_TWO < 10000 THEN "AFFORDABLE"
WHEN AVERAGE_COST_FOR_TWO >= 10000 AND AVERAGE_COST_FOR_TWO < 50000 THEN "LESS AFFORDABLE"
WHEN AVERAGE_COST_FOR_TWO >= 50000 AND AVERAGE_COST_FOR_TWO < 100000 THEN 'EXPENSIVE'
WHEN AVERAGE_COST_FOR_TWO >= 100000 THEN "LUXURIOUS"
ELSE 'NOT'
END;

CREATE TABLE ZOMATO_DATA12
(Restaurant_ID INT,
Restaurant_Name VARCHAR(200),
CountryCode INT,
City VARCHAR(100),
Address VARCHAR(250),
Locality VARCHAR(250),
Locality_Verbose VARCHAR(800),
Longitude decimal(20,6),
Latitude decimal(20,5),
Cuisines VARCHAR(255),
Currency varchar(50),
Has_Table_booking VARCHAR(20),
Has_Online_delivery VARCHAR(20),
Is_delivering_now VARCHAR(20),
Switch_to_order_menu VARCHAR(20),
Price_range INT,
Votes INT,
Average_Cost_for_two INT,
Rating int,
Datekey_Opening DATE,
Cuisines_1 VARCHAR(30),
Cuisines_2 VARCHAR(30),
Cuisines_3 VARCHAR(30),
Cuisines_4 VARCHAR(30) ,
Cuisines_5 VARCHAR(30) ,
Cuisines_6 VARCHAR(30) ,
Cuisines_7 VARCHAR(30) ,
Cuisines_8 VARCHAR(30))
partition by RANGE (AVERAGE_COST_FOR_TWO)
( partition P0 values less than (1000),
 partition P1 values less than (10000),
 partition P2 values less than (50000),
 partition P3 values less than (100000),
 partition P4 values less than (500000),
 partition P5 values less than (900000));
 
 DROP TABLE ZOMATO_DATA12;
 
LOAD DATA INFILE
'E:/zomato1.csv'
into table ZOMATO_DATA12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT PARTITION_NAME, TABLE_NAME, TABLE_ROWS FROM
INFORMATION_SCHEMA.PARTITIONS WHERE TABLE_NAME = "ZOMATO_DATA12";

CREATE TABLE ZOMATO_DATA22
(Restaurant_ID INT,
Restaurant_Name VARCHAR(200),
CountryCode INT,
City VARCHAR(100),
Address VARCHAR(250),
Locality VARCHAR(250),
Locality_Verbose VARCHAR(800),
Longitude decimal(20,6),
Latitude decimal(20,5),
Cuisines VARCHAR(255),
Currency varchar(50),
Has_Table_booking VARCHAR(20),
Has_Online_delivery VARCHAR(20),
Is_delivering_now VARCHAR(20),
Switch_to_order_menu VARCHAR(20),
Price_range INT,
Votes INT,
Average_Cost_for_two INT,
Rating int,
Datekey_Opening DATE,
Cuisines_1 VARCHAR(30),
Cuisines_2 VARCHAR(30),
Cuisines_3 VARCHAR(30),
Cuisines_4 VARCHAR(30) ,
Cuisines_5 VARCHAR(30) ,
Cuisines_6 VARCHAR(30) ,
Cuisines_7 VARCHAR(30) ,
Cuisines_8 VARCHAR(30))
partition by HASH(AVERAGE_COST_FOR_TWO)
PARTITIONS 6;
SELECT * FROM ZOMATO_DATA22;
SELECT PARTITION_NAME, TABLE_NAME, TABLE_ROWS FROM
INFORMATION_SCHEMA.PARTITIONS WHERE TABLE_NAME = 'ZOMATO_DATA22';

##7.Percentage of Resturants based on "Has_Table_booking"

SELECT Has_Table_booking, COUNT(RESTAURANT_ID)*100/(SELECT COUNT(RESTAURANT_ID) FROM ZOMATO_DATA)
AS "PERCENTAGE OF REST" FROM ZOMATO_DATA GROUP BY HAS_TABLE_BOOKING;

##8.Percentage of Resturants based on "Has_Online_delivery" 

SELECT Has_ONLINE_DELIVERY, COUNT(RESTAURANT_ID)*100/(SELECT COUNT(RESTAURANT_ID) FROM ZOMATO_DATA)
AS "PERCENTAGE OF REST" FROM ZOMATO_DATA GROUP BY HAS_ONLINE_DELIVERY;
