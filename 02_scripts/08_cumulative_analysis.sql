/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics
    - To track performance over time cumulatively
    - Useful for growth analysis or identifying long-term trends

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/


-- Total sales per month + the running total that restarts every year
SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM 	
(
	SELECT 
		DATE_TRUNC('month', order_date)::DATE AS order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL 
	GROUP BY DATE_TRUNC('month', order_date)
)

-- Total sales per year + the running total of sales over time
SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM 	
(
	SELECT 
		DATE_TRUNC('year', order_date)::DATE AS order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL 
	GROUP BY DATE_TRUNC('year', order_date)
)


-- Find the moving average
SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	ROUND(AVG(avg_price) OVER (ORDER BY order_date), 0) AS moving_average_price
FROM 	
(
	SELECT 
		DATE_TRUNC('year', order_date)::DATE AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL 
	GROUP BY DATE_TRUNC('year', order_date)
)










