-- Retail Sales SQL Project - P1
-- Import data source in the database

SELECT * FROM retail_sales;

--Data Cleaning and exploration

--How many sales we have?

SELECT COUNT (*) as total_sale FROM retail_sales

--How many uniuqye customer we have?
SELECT COUNT (DISTINCT customer_id) as customers FROM retail_sales

--How many distinct category we have
SELECT DISTINCT category FROM retail_sales

-- Check for null value

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	age IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--DELETE NULL VALUE

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	age IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;


--Data Analysis & Business Problems

--Q1. Write a sql query to retrieve all columns for sales made on ' 2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date ='2022-11-05';

--Q2 Write a sql query to retrieve all transactions where the category is 'Clothing' and the quanity sold is more than 4 in the month of Nov-2022
--FORMAT(sale_date,'YYYY-MM') = '2022-11' - In SQL Server, you use CONVERT() or FORMAT() instead, depending on what you want to do.
	--TO_CHAR(sales_date,'yyyy-mm') = "2022-11" - TO_CHAR is an Oracle (and PostgreSQL) function
SELECT *
FROM retail_sales
WHERE
	category = 'Clothing'
	AND 
	sale_date Between '2022-11-01' AND '2022-11-30'
	AND
	quantiy >= 4;

--Q3 Write a SQL query to calculate the total sales( total _sale) for each category

SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

--Q4 Write a SQL query to find the average age of customers who purchased items from the "Beauty" category

SELECT
	AVG(age) as average_age_of_customer
FROM retail_sales
WHERE
	category = 'Beauty';

--Q5 Write a SQL query to find all transactions where the total_sales is greater than 1000.

SELECT * 
FROM retail_sales
WHERE 
	total_sale > 1000;

--Q6 Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category

SELECT
		category,
		gender,
		COUNT(*) as total_transactions
FROM retail_sales
Group by category,gender
ORDER BY category;

--Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT *
FROM (
SELECT
	YEAR(sale_date) as year,
	MONTH(sale_date) as month,
	AVG(total_sale) as Average_sales,
	RANK() OVER(PARTITION BY YEAR(sale_date)
				ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY YEAR(sale_date),MONTH(sale_date)) as t1
WHERE rank = 1;

--Q8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT
	customer_id,
	SUM(total_sale) as Net_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--Q9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT( DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

--Q 10. Write a SQL query to create each shift and number of orders (Example Morning < 12, Aftenrnoon Between 12 and 17,Evening >17)
WITH hourly_table
AS
(
SELECT *,
	CASE
		WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_table
GROUP BY shift;


--End of the project