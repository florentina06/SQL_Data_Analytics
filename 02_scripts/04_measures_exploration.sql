/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - Calculate aggregated metrics (totals, averages) for quick insights
    - Identify overall trends or spot anomalies

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales -- 29.356.250

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales -- 60.423

-- Find the average selling price
SELECT ROUND(AVG(price), 2) AS avg_price FROM gold.fact_sales -- 486.04

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales -- 60.398

SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales -- 27.659

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products -- 295

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customer -- 18.484

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales -- 18.484


-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customer




