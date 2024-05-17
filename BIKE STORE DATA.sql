CREATE DATABASE BIKE_STORE_DATA;
USE BIKE_STORE_DATA;

CREATE TABLE BIKE_STORE (
ORDER_ID INT,
CUSTOMERS VARCHAR(30),
CITY VARCHAR(50),
STATE VARCHAR(5),
ORDER_DATE date,
TOTAL_UNITS INT,
REVENUE DECIMAL(10,2),
PRODUCT_NAME VARCHAR(60),
CATEGORY_NAME VARCHAR(20),
BRAND_NAME VARCHAR(15),
STORE_NAME VARCHAR(20),
SALES_REP VARCHAR(20));

LOAD DATA INFILE
'E:/BikeStores.csv'
into table BIKE_STORE
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM BIKE_STORE;
DROP TABLE bike_store;

#Q-1 Find total revenue earned by each customer grouped by brand and store name and order them from largest to smallest?
SELECT SUM(REVENUE) AS TOTAL_REVENUE, CUSTOMERS,BRAND_NAME, STORE_NAME
FROM BIKE_STORE GROUP BY BRAND_NAME, STORE_NAME, CUSTOMERS
ORDER BY TOTAL_REVENUE DESC; 

#Q-2 Find maximum revenue for unique Customers where state is Califonia (CA) with respect to order date?

SELECT MAX(REVENUE) AS MAX_REVENUE, CUSTOMERS, ORDER_DATE, STATE FROM BIKE_STORE
WHERE STATE = "CA" GROUP BY CUSTOMERS, ORDER_DATE ORDER BY MAX_REVENUE;

#Q-3 Find unique customers whose revenue falls between 1000 to 8000 with respect to category and Sales representative?
SELECT distinct(CUSTOMERS) AS CUSTOMERS, CATEGORY_NAME, SALES_REP, REVENUE FROM bike_store
WHERE REVENUE between 1000 AND 8000;

#Q-4 Find records where city is utica, duarte and Houston?
SELECT * FROM BIKE_STORE WHERE CITY in ("UTICA","DUARTA","HOUSTON"); ##right

#Q-5 Which is the most common product name based on maximum revenue?
SELECT PRODUCT_NAME, MAX(REVENUE) MAX_REVENUE FROM BIKE_STORE 
GROUP BY PRODUCT_NAME order by MAX_REVENUE DESC ; ##right

#Q-6 Find Category where name starts with 'C' and ends with 'S' for all records?
SELECT * FROM BIKE_STORE WHERE CATEGORY_NAME LIKE "C%S"; ##right

#Q-7 Find revenue for customers where average revenue is greater than 1000 with respect to city, Brand Name and Order ID?
SELECT ORDER_ID, CITY, BRAND_NAME, CUSTOMERS, 
AVG(REVENUE) AS AVG_Revenue FROM bike_store GROUP BY customers, 
order_id, brand_name, city having avg_revenue > 1000; 

#Q-8 Find records where First name of Customer starts with 'j' and inbetween alphabet is 'h' and last alphabet is 'n'?
select * FROM bike_store WHERE CUSTOMERS LIKE "J%H%N"; ##RIGHT

#Q-9 Find all records where brand name is not surly and trek.
select * FROM bike_store WHERE BRAND_NAME NOT in ("SURLY","TREK") ; ##RIGHT

#Q-10 Find records from BikeStores where revenue is equal to mimumum of revenue
select * FROM bike_store WHERE REVENUE = (SELECT MIN(REVENUE) FROM bike_store); ##RIGHT

#Q-11 Which particular day has the customer earned the minimum revenue?
ALTER TABLE bike_store
ADD COLUMN `day` varchar(10);
UPDATE bike_store SET `day` = day(ORDER_DATE);
SELECT `day`, CUSTOMERS, revenue  FROM bike_store where revenue =  
(SELECT MIN(REVENUE) FROM bike_store); 

#Q-12 Find unique units when grouped by store name and sales representative for all customers.


select distinct(TOTAL_UNITS), STORE_NAME, SALES_REP, 
COUNT(CUSTOMERS) AS NUMBERS_OF_CUSTOMERS FROM bike_store 
GROUP BY TOTAL_UNITS, STORE_NAME, SALES_REP ORDER BY NUMBERS_OF_CUSTOMERS; 

#Q-13 Which month has total revenue more than 2000 with respect to customer and order date?

ALTER TABLE bike_store
ADD COLUMN `MONTH` INT;
UPDATE bike_store SET `MONTH` = MONTH(ORDER_DATE);
set sql_safe_updates =0;
SELECT CUSTOMERS, ORDER_DATE, SUM(REVENUE) AS TOTAL_REVENUE,
`MONTH` FROM bike_store GROUP BY CUSTOMERS, ORDER_DATE, `MONTH` 
HAVING TOTAL_REVENUE > 2000;
