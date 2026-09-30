# SQL Retail Sales Analysis

This project analyzes retail sales data using MySQL. The analysis covers data cleaning, data exploration, and business questions related to sales, customers, product categories, and purchasing patterns.

## Data Cleaning

The raw retail sales data was checked for missing values. Zero values in selected numerical fields were treated as missing values, and incomplete records were removed before analysis.

```sql
UPDATE retail_sales
SET 
    quantity = NULLIF(quantity, 0),
    price_per_unit = NULLIF(price_per_unit, 0),
    cogs = NULLIF(cogs, 0),
    total_sale = NULLIF(total_sale, 0);
```

## Data Exploration

### Total Records, Quantity and Sales

```sql
SELECT 
    COUNT(*) AS total_records,
    SUM(quantity) AS total_quantity,
    SUM(total_sale) AS total_sales
FROM retail_sales;
```

### Unique Customers

```sql
SELECT 
    COUNT(DISTINCT customer_id) AS customers
FROM retail_sales;
```

### Number of Categories

```sql
SELECT 
    COUNT(DISTINCT category) AS categories
FROM retail_sales;
```

### Categories

```sql
SELECT DISTINCT 
    category
FROM retail_sales;
```

## Business Analysis

### Q1. Retrieve all columns for sales made on 2022-11-05.

```sql
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

**Output:** 11 transactions.

[View Q1 Output](Q1_solution.csv)

---

### Q2. Retrieve all Clothing transactions where the quantity sold is more than 4 in November 2022.

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
    AND quantity >= 4
    AND YEAR(sale_date) = 2022
    AND MONTH(sale_date) = 11
ORDER BY sale_date ASC;
```

**Output:** 17 transactions.

[View Q2 Output](Q2_solution.csv)

---

### Q3. Calculate the total sales for each category.

```sql
SELECT 
    category,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;
```

| Category    | Total Sales |
| ----------- | ----------: |
| Beauty      |      286840 |
| Clothing    |      311070 |
| Electronics |      313810 |

---

### Q4. Find the average age of customers who purchased items from the Beauty category.

```sql
SELECT 
    AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

| Average Age |
| ----------: |
|     40.3497 |

---

### Q5. Find all transactions where the total sale is greater than 1000.

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

**Output:** 306 transactions.

[View Q5 Output](Q5_solution.csv)

---

### Q6. Find the total number of transactions made by each gender in each category.

```sql
SELECT 
    gender,
    category,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY gender, category;
```

| Gender | Category    | Total Transactions |
| ------ | ----------- | -----------------: |
| Female | Beauty      |                330 |
| Female | Clothing    |                347 |
| Female | Electronics |                340 |
| Male   | Beauty      |                282 |
| Male   | Clothing    |                354 |
| Male   | Electronics |                344 |

---

### Q7. Calculate the average sale for each month.

```sql
SELECT 
    MONTH(sale_date) AS month,
    AVG(total_sale) AS avg_sale
FROM retail_sales
GROUP BY MONTH(sale_date)
ORDER BY avg_sale DESC;
```

| Month | Average Sale |
| ----: | -----------: |
|     4 |     477.6415 |
|    12 |     476.5940 |
|     9 |     470.2909 |
|     7 |     464.9600 |
|     5 |     464.1964 |
|    11 |     463.4191 |
|     6 |     457.1212 |
|     3 |     454.8990 |
|     2 |     453.6264 |
|     8 |     441.6518 |
|     1 |     441.3021 |
|    10 |     432.3333 |

---

### Q8. Find the top 5 customers based on total sales.

```sql
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

| Customer ID | Total Sales |
| ----------: | ----------: |
|           3 |       38440 |
|           1 |       30750 |
|           5 |       30405 |
|           2 |       25295 |
|           4 |       23580 |

---

### Q9. Find the number of unique customers who purchased items from each category.

```sql
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS customers
FROM retail_sales
GROUP BY category
ORDER BY category;
```

| Category    | Unique Customers |
| ----------- | ---------------: |
| Beauty      |              141 |
| Clothing    |              149 |
| Electronics |              144 |

---

### Q10. Find the number of orders in each sales shift.

Morning: Before 12
Afternoon: 12 to 16
Evening: After 16

```sql
WITH hourly_shift AS
(
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
    COUNT(*) AS total_orders
FROM hourly_shift
GROUP BY shift
ORDER BY FIELD(shift, 'Morning', 'Afternoon', 'Evening');
```

| Shift     | Total Orders |
| --------- | -----------: |
| Morning   |          558 |
| Afternoon |          164 |
| Evening   |         1275 |

## Project Files

```text
SQL-Retail-Sales-Analysis/
│
├── retail_sales_raw_file.csv
├── retail_sales_cleaned.csv
│
├── Q1_solution.csv
├── Q2_solution.csv
├── Q3_solution.csv
├── Q4_solution.csv
├── Q5_solution.csv
├── Q6_solution.csv
├── Q7_solution.csv
├── Q8_solution.csv
├── Q9_solution.csv
├── Q10_solution.csv
│
├── Retail_Sales_Analysis.sql
└── README.md
```
