/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights
    - For customer segmentation, product categorization, or regional analysis

SQL Functions Used:
    - CASE: Defines custom segmentation logic
    - GROUP BY: Groups data into segments
===============================================================================
*/


/* Group customers into three segments based on their spending behavior:
 		- VIP: Customers with at least 12 months of history and spending more than 5000 euro
 		- Regular: Customers with at least 12 months of history but spending 5000 euro or less
 		- New: Customers with a lifespan less than 12 months
 	And find the total number of customers by each group 
 */

WITH customer_spending AS (
	SELECT 
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
	  (EXTRACT(YEAR FROM MAX(f.order_date)) - EXTRACT(YEAR FROM MIN(f.order_date))) * 12
	     + EXTRACT(MONTH FROM MAX(f.order_date)) - EXTRACT(MONTH FROM MIN(f.order_date)) AS lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customer c
		ON f.customer_key = c.customer_key
	GROUP BY c.customer_key	
)

SELECT 
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM (
	SELECT 
		customer_key,
		CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
					WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
				 ELSE 'New'	
		END AS customer_segment
	FROM customer_spending
)
GROUP BY customer_segment
ORDER BY total_customers DESC
  


