CREATE DATABASE GLOBLESUPERSTORE;
USE GLOBLESUPERSTORE;
SELECT * FROM GlobalSuperstore2018;
SHOW TABLES;
RENAME TABLE `GlobalSuperstore2018` TO `SUPERSTORE`;

-- Q.1) Find the total revenue, quantities and profit generated.
SELECT
    SUM(Sales) AS Total_Revenue,
    SUM(Quantity) AS Total_Quantity,
    SUM(Profit) AS Total_Profit
FROM superstore;

-- Q.2) Find the segment wise distribution of the sales.
SELECT
    Segment,
    SUM(Sales)  AS Total_Sales
    FROM superstore
    GROUP BY Segment
    ORDER BY Total_Sales DESC;
 
-- Q.3) Find the top 3 most profitable products.
SELECT 
`Product Name`,
SUM(Profit) AS total_profit
FROM superstore
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 3;
 
-- Q.4) How many orders are placed after January 2016.
SELECT 
COUNT(DISTINCT `Order ID`) AS total_orders_after_jan_2016
FROM superstore
WHERE STR_TO_DATE(`Order Date`, '%d-%m-%Y') > '2016-01-31';
 
-- Q.5) How many states from Austria are under the roof of business?
SELECT 
COUNT(DISTINCT `State`) AS total_states_in_austria
FROM superstore
WHERE Country = 'Austria';
 
-- Q.6) Which products and subcatagories are most and least profitable?
-- Most profitable product
SELECT 
`product name`,
SUM(profit) AS total_profit
FROM superstore
GROUP BY `product name`
ORDER BY total_profit DESC
LIMIT 1;
 
-- Least profitable product
SELECT 
`product name`,
SUM(profit) AS total_profit
FROM superstore
GROUP BY `product name`
ORDER BY total_profit ASC
LIMIT 1;
 
-- Q.7 Which customer segment contributes the most to the total revenue?
SELECT 
segment,
SUM(sales) AS total_revenue
FROM superstore
GROUP BY segment
ORDER BY total_revenue DESC;
 
-- Q.8) Wahat is the year-over-year growth in sales and profit?
SELECT 
YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS order_year,
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM superstore
GROUP BY YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y'))
ORDER BY order_year;
 
-- Q.9) Which countries and cities are driving the highest sales?
SELECT 
country,
SUM(sales) AS total_sales
FROM superstore
GROUP BY country
ORDER BY total_sales DESC
limit 10;
 
-- Q.10) What is the average delivery time from order to ship date across regions?
SELECT 
region,
ROUND(AVG(DATEDIFF(
STR_TO_DATE(`Ship Date`, '%d-%m-%Y'),
STR_TO_DATE(`Order Date`, '%d-%m-%Y')
)), 2) AS avg_delivery_days
FROM superstore
GROUP BY region
ORDER BY avg_delivery_days;
 
-- .11) what is the profit distribution across order priority?
SELECT 
`Order Priority`,
SUM(profit) AS total_profit,
ROUND(AVG(profit), 2) AS avg_profit_per_order
FROM superstore
GROUP BY `Order Priority`
ORDER BY total_profit DESC;
 
-- Q.12) Suggest data-driven recommendations for improving profit and reducing losses.
SELECT 
`Sub-Category`, 
SUM(sales) AS total_sales, 
SUM(profit) AS total_profit
FROM superstore
GROUP BY `Sub-Category`
ORDER BY 
total_profit ASC
LIMIT 10;
 
