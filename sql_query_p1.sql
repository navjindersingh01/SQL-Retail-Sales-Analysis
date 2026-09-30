-- SQL Retail Sales Analysis 
CREATE DATABASE project_1;
USE project_1;

-- Create the table
CREATE TABLE retail_sales (
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit INT,
cogs INT,
total_sale INT
);

-- Data Cleaning
-- Checking for null values in the rows
SELECT * 
FROM retail_sales
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
    age IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL
    OR
    category IS NULL;

UPDATE retail_sales
SET quantiy = NULLIF(quantiy, 0),
	price_per_unit = NULLIF(price_per_unit, 0),
    cogs = NULLIF(cogs, 0),
    total_sale = NULLIF(total_sale, 0);

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
    age IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL
    OR
    category IS NULL;

SELECT *
FROM retail_sales;

SELECT count(*)
FROM retail_sales;

-- Data Exploration

-- How many sales we have? 

SELECT 
	COUNT(*) as total_records,
	SUM(quantity) as total_quantity,
	SUM(total_sale) as total_sales
FROM retail_sales;

-- How many unique customers we have? 

SELECT 
	count(DISTINCT customer_id) as customers
FROM retail_sales;

-- How many categories we have?

SELECT 
	COUNT(DISTINCT category) as categories
FROM retail_sales;

-- What are the names of the categories we have?

SELECT 
	DISTINCT category as categories
FROM retail_sales ;

-- Data Anlaysis and Business Problems

-- Q1: Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- 	   and the quantity sold is more than 4 in the month of Nov-2022.

SELECT *
FROM retail_sales
WHERE
	category = 'Clothing' 
    AND quantity >=4
    AND YEAR(sale_date) = 2022
    AND MONTH(sale_date) = 11
ORDER BY sale_date ASC;

-- Q3: Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category AS Category,
    SUM(total_sale) AS 'Total Sales'
FROM retail_sales
GROUP BY category;

-- Q4: Write a SQL query to find the average age of customers who purchased items from 
--     the 'Beauty' category.

SELECT 
	AVG(age) as Avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Write a SQL query to find the total number of transactions (transaction_id) made by 
--     each gender in each category.

SELECT 
	gender,
    category,
	COUNT(transactions_id)
FROM retail_sales
GROUP BY 
	gender, 
    category
ORDER BY 
	gender,
    category;

-- Q7: Write a SQL query to calculate the average sale for each month. Find out best selling 
--     month in each year.

SELECT 
	MONTH(sale_date) AS Months,
	AVG(total_sale) AS Avg_Sale
FROM retail_sales
GROUP BY
	1
ORDER BY 
	2 DESC;

-- Q8: Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id AS 'Customer ID',
    SUM(total_sale) AS 'Total Sales'
FROM retail_sales
GROUP by 
	1
ORDER BY
	2 DESC
LIMIT 5;

-- Q9: Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category AS Category,
	count(DISTINCT customer_id) AS Customers
FROM retail_sales
GROUP BY
	1
ORDER BY 
	1;

-- Q10: Write a SQL query to create each shift and number of orders (Example Morning <12, 
--      Afternoon Between 12 & 17, Evening >17).

-- With CTE (common table expression):
WITH hourly_shift
AS (
	SELECT *,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 16 THEN 'Afternoon'
            ELSE 'Evening'
		END AS shift
	FROM retail_sales
)
SELECT 
	shift,
    count(*) AS total_orders
FROM hourly_shift
GROUP BY shift
ORDER BY 
	FIELD(shift,'Morning','Afternoon','Evening');

