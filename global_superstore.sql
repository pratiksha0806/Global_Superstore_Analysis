CREATE DATABASE PROJECTDB;
USE PROJECTDB; 
SELECT * FROM ORDER_DETAILS;
SELECT * FROM ORDERS;
SELECT * FROM PIZZA_TYPES;
SELECT * FROM PIZZAS;

-- Basic:
-- 1. Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_orders
FROM orders;


-- 2. Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;



-- 3. Identify the highest-priced pizza
SELECT pt.name AS pizza_name, p.price AS highest_price
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;



























-- 4. Identify the most common pizza size ordered.
SELECT p.size, SUM(od.quantity) AS total_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_ordered DESC
LIMIT 1;



























-- 5. List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name AS pizza_type, SUM(od.quantity) AS total_quantity_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity_ordered DESC
LIMIT 5;


























-- Intermediate:
-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;


























-- 7. Determine the distribution of orders by hour of the day.
SELECT HOUR(time) AS order_hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY HOUR(time)
ORDER BY order_hour;























-- 8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT pt.category, COUNT(p.pizza_id) AS total_pizzas
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas DESC;



























-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(daily_pizzas), 2) AS avg_pizzas_per_day
FROM (SELECT o.date, SUM(od.quantity) AS daily_pizzas
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.date) AS daily_summary;































-- 10. Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.name AS pizza_type, ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;



























-- Advanced:
-- 11. Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.name AS pizza_type, ROUND(SUM(od.quantity * p.price), 2) AS pizza_revenue, ROUND((SUM(od.quantity * p.price) /
(SELECT SUM(od2.quantity * p2.price)
FROM order_details od2
JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id)) * 100,2)
AS percentage_contribution
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY percentage_contribution DESC;


















-- 12. Analyze the cumulative revenue generated over time.
SELECT daily_sales.order_date, daily_sales.daily_revenue,
 ROUND(SUM(daily_sales.daily_revenue) 
 OVER (ORDER BY daily_sales.order_date),2) 
 AS cumulative_revenue
FROM (SELECT o.date AS order_date,
ROUND(SUM(od.quantity * p.price), 2)
AS daily_revenue
FROM orders o 
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date) 
AS daily_sales;













-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
WITH revenue_per_pizza AS (SELECT pt.category, pt.name AS pizza_type,
SUM(od.quantity * p.price) AS total_revenue,
ROW_NUMBER() OVER (PARTITION BY pt.category 
ORDER BY SUM(od.quantity * p.price) DESC) AS rn
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, pt.name)
SELECT category, pizza_type,
ROUND(total_revenue, 2) AS revenue
FROM revenue_per_pizza
WHERE rn <= 3
ORDER BY category, revenue DESC;


