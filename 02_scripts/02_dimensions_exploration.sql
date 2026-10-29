/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - Explore the structure of dimension tables

SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- A list of unique countries from which customers originate
SELECT DISTINCT
    country
FROM gold.dim_customer
ORDER BY country

-- A list of unique categories, subcategories, and products
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name



