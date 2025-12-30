-- =====================================================
-- Superstore Sales Analysis
-- Role: Business / Operations Analyst + Data Analyst
-- Database: SQLite
-- =====================================================
-- 1. Executive KPIs
-- =====================================================

SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) AS profit_margin,
    AVG(delivery_days) AS avg_delivery_days
FROM sales_table;


-- =====================================================
-- 2. Sales & Profit by Region
-- =====================================================

SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_table
GROUP BY region
ORDER BY total_sales DESC;


-- =====================================================
-- 3. Category Profitability (Weighted)
-- =====================================================

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin
FROM sales_table
GROUP BY category
ORDER BY weighted_profit_margin DESC;


-- =====================================================
-- 4. Delivery Speed vs Profitability
-- =====================================================

SELECT
    delivery_speed,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin
FROM sales_table
GROUP BY delivery_speed
ORDER BY weighted_profit_margin DESC;



SELECT order_date, ship_date
FROM sales_table
LIMIT 5;


SELECT 
  strftime ('%Y-%m' , order_date) as order_month,
  SUM(sales) AS total_sales, 
  SUM(profit) AS total_profit,
  SUM(profit) / SUM(sales) AS weighted_profit_margin
  FROM sales_table
  GROUP BY order_month
  ORDER BY order_month;
  
 WITH monthly AS (
  SELECT
    strftime('%Y-%m', order_date) AS order_month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin
  FROM sales_table
  GROUP BY order_month
)
-- Also calculating Month over Month growth in %
SELECT
  order_month,
  total_sales,
  total_profit,
  weighted_profit_margin,
  LAG(total_sales) OVER (ORDER BY order_month) AS prev_month_sales,
  ROUND(
    (total_sales - LAG(total_sales) OVER (ORDER BY order_month))
    / NULLIF(LAG(total_sales) OVER (ORDER BY order_month), 0)
    * 100.0
  , 2) AS mom_sales_growth
FROM monthly
ORDER BY order_month;

-- =====================================================
-- 6. Discount Impact Analysis 
-- =====================================================
  
  SELECT
  CASE
    WHEN discount = 0 THEN 'No Discount'
    WHEN discount > 0 AND discount <= 0.10 THEN 'Low (0–10%)'
    WHEN discount > 0.10 AND discount <= 0.20 THEN 'Medium (10–20%)'
    WHEN discount > 0.20 AND discount <= 0.30 THEN 'High (20–30%)'
    ELSE 'Very High (>30%)'
  END AS discount_band,
  COUNT(*) AS order_count,
  SUM(sales) AS total_sales,
  SUM(profit) AS total_profit,
  SUM(profit) / SUM(sales) AS weighted_profit_margin
FROM sales_table
GROUP BY discount_band
ORDER BY weighted_profit_margin DESC;

-- =====================================================
-- 7. Customer and Segment Analysis 
-- =====================================================
   SELECT
    segment,
    COUNT(*) AS order_count,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin
FROM sales_table
GROUP BY segment
ORDER BY weighted_profit_margin DESC;
  
WITH top10 AS (
SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_customer_sales,
    SUM(profit) AS total_customer_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin_customer
FROM sales_table
GROUP BY customer_id, customer_name
ORDER BY total_customer_sales DESC
LIMIT 10
),

top10_sum AS ( 
    SELECT SUM(total_customer_sales) as top10_customer_sales
    FROM top10 
),

all_sum as (
    SELECT SUM(sales) as total_sales_all
    FROM sales_table
)

SELECT
    all_sum.total_sales_all,
    top10_sum.top10_customer_sales,
    ROUND(top10_sum.top10_customer_sales * 100.00 / all_sum.total_sales_all,2) as percentage_of_sales_top10,
    (all_sum.total_sales_all - top10_sum.top10_customer_sales) as non_top10
FROM top10_sum, all_sum;

-- =====================================================
-- 8. Loss making customers 
-- =====================================================

SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_customer_sales,
    SUM(profit) AS total_customer_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin_customer


FROM sales_table
GROUP BY  customer_id, customer_name
HAVING SUM(sales) > 3000 AND SUM(profit) < 0
ORDER BY total_customer_sales DESC
LIMIT 10;

-- =====================================================
-- 9. Loss making products 
-- =====================================================
SELECT
    product_id,
    product_name,
    SUM(sales)  AS total_product_sales,
    SUM(profit) AS total_product_profit,
    SUM(profit) / SUM(sales) AS product_profit_margin
FROM sales_table
GROUP BY product_id, product_name
HAVING SUM(profit) < 0
ORDER BY total_product_profit ASC
LIMIT 10;

-- Identify if product losses related to high discounts


SELECT
    product_id,
    product_name,
    SUM(sales)  AS total_product_sales,
    SUM(profit) AS total_product_profit,
    SUM(profit) / SUM(sales) AS product_profit_margin,
    AVG(discount) as avg_discount
FROM sales_table
GROUP BY product_id, product_name
HAVING SUM(profit) < 0
ORDER BY avg_discount DESC
LIMIT 10; 

-- Identify if product 'OFF-BI-10004995' losing money for everyone or only for certain customers

SELECT 
    customer_id,
    customer_name,
    SUM(sales) AS total_customer_sales,
    SUM(profit) AS total_customer_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin_customer
FROM sales_table
WHERE product_id = 'OFF-BI-10004995'
GROUP BY customer_id, customer_name
HAVING SUM(profit) < 0
ORDER BY total_customer_profit ASC;

--Check the product for all customers

SELECT 
    customer_id,
    customer_name,
    SUM(sales) AS total_customer_sales,
    SUM(profit) AS total_customer_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin_customer
FROM sales_table
WHERE product_id = 'OFF-BI-10004995'
GROUP BY customer_id, customer_name
ORDER BY weighted_profit_margin_customer ASC;

--  Compare disount levels across customers for a single product 'OFF-BI-10004995'

SELECT 
    customer_id,
    customer_name,
    AVG(discount) as avg_discount,
    SUM(sales) AS total_customer_sales,
    SUM(profit) AS total_customer_profit,
    SUM(profit) / SUM(sales) AS weighted_profit_margin_customer
FROM sales_table
WHERE product_id = 'OFF-BI-10004995'
GROUP BY customer_id, customer_name;

-- Analyze profitability at the order level for a single product to understand whether order size impacts profit margin

SELECT
    order_id,
    order_date,
    SUM(sales) AS order_sales,
    SUM(profit) AS order_profit,
    SUM(profit) / SUM(sales) AS order_profit_margin
FROM sales_table
WHERE product_id = 'OFF-BI-10004995'
GROUP BY order_id, order_date
ORDER BY order_sales ASC;

-- Analyze whether losses are persistent or concentrated in specific periods

SELECT
     strftime('%Y-%m', order_date) AS month,
    SUM(sales)  AS monthly_sales,
    SUM(profit) AS monthly_profit,
    SUM(profit) / SUM(sales) AS monthly_profit_margin,
    AVG(discount) AS avg_monthly_discount
FROM sales_table
WHERE product_id = 'OFF-BI-10004995'
GROUP BY 1
ORDER BY month;



