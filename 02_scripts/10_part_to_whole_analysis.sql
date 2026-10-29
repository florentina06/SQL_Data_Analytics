/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To find the proportion of each part relative to the whole
    - To see which categories contribute the most to overall sales

SQL Functions Used:
    - SUM(): Aggregates values per category
    - Window Functions: SUM() OVER() for the overall total
===============================================================================
*/

-- Which categories contribute the most to the overall sales?
 -- bikes represent 96.46 %, while accessories 2.39% and clothing 1.16%
 -- if one category is dominating the business -> you are over relying on one category and if this fails => the whole business will fail

WITH category_sales AS (
	SELECT 
		category,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
	GROUP BY category
)
SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	ROUND((total_sales / SUM(total_sales) OVER () ) * 100, 2) || '%' AS percentage_of_total
FROM category_sales	
ORDER BY total_sales DESC 


-- subcategory -> road bikes sell the most with 49%, followed by mountain bikes with 33%
WITH subcategory_sales AS (
	SELECT 
		subcategory,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
	GROUP BY subcategory
)
SELECT 
	subcategory,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	ROUND((total_sales / SUM(total_sales) OVER () ) * 100, 2) || '%' AS percentage_of_total
FROM subcategory_sales	
ORDER BY total_sales DESC 


-- quantity instead of sales_amount: by quantity, accessories sell the most with 59%, followed by bikes with 25%; this means bikes bring high sales because they are expensive
WITH category_quantity AS (
	SELECT 
		category,
		SUM(quantity) AS total_quantity
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
	GROUP BY category
)
SELECT 
	category,
	total_quantity,
	SUM(total_quantity) OVER () AS overall_quantity,
	ROUND((total_quantity / SUM(total_quantity) OVER () ) * 100, 2) || '%' AS percentage_of_total
FROM category_quantity	
ORDER BY total_quantity DESC 



-- sales by country -> USA and Australia bring the highest sales, each representing 31% of the total; Canada is in last place
WITH country_sales AS (
	SELECT 
		c.country,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customer c ON c.customer_key = f.customer_key 
	WHERE c.country <> 'n/a'
	GROUP BY c.country
)
SELECT 
	country,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	ROUND((total_sales / SUM(total_sales) OVER () ) * 100, 2) || '%' AS percentage_of_total
FROM country_sales
ORDER BY total_sales desc



-- Segment products into cost ranges and count how many products fall into each segment
   -- a lot of products cost under 100 -> maybe the business consists mostly of accessories
WITH product_segments AS (
WITH product_segments AS (
	SELECT
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below 100'
				 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
				 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
				 ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)
SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC 

