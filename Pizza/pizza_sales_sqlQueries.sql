USE pizza;

SELECT * FROM pizza_sales;

-- KPI's Requirements

-- 1. Total Revenue:

SELECT 
	ROUND(SUM(total_price), 2) AS Total_Revenue 
FROM pizza_sales;

-- 2. Average Order Value --> dividing total revenue by total number of order

SELECT 
	ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS Average_Order_Value 
FROM pizza_sales;

-- 3. Total Pizzas sold --> sum of all the quantities of pizza sold
SELECT 
	SUM(quantity) AS Total_Pizza_Sold 
FROM pizza_sales;

-- 4. Total orders 
SELECT 
	COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales;

-- 5. Average pizzas per order --> total pizzas sold / total orders

SELECT 
	SUM(quantity) / COUNT(DISTINCT order_id) AS Average_pizza_per_order 
FROM pizza_sales;


-- Chart Requirements
-- 1. Daily trends for total orders

SELECT 
	DAYNAME(order_date) AS order_day, 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY order_day;

-- 2. Monthly trends for total orders

SELECT 
	MONTHNAME(order_date) AS order_day, 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY order_day;

-- 3. % of sales by pizza category
SELECT 
	pizza_category, 
    SUM(total_price)*100 / (SELECT SUM(total_price) FROM pizza_sales) AS Percentage_of_sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Percentage_of_sales DESC;

-- 4. % of sales by pizza size
SELECT pizza_size, SUM(total_price)*100 / (SELECT SUM(total_price) FROM pizza_sales) AS Percentage_of_sales_by_pizzaSize
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Percentage_of_sales_by_pizzaSize DESC;

-- 5. total pizza sold by category
SELECT pizza_category, SUM(quantity) AS total_pizza_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_pizza_sold DESC;

-- 6. Top 5 pizzas by revenue
SELECT pizza_name, sum(total_price) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC LIMIT 5;

-- 6. Bottom 5 pizzas by revenue
SELECT pizza_name, SUM(total_price) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue ASC LIMIT 5;

-- 6. Top 5 pizzas by quantity

SELECT pizza_name, SUM(quantity) AS total_quantity_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity_sold DESC LIMIT 5;

-- 6. Bottom 5 pizzas by quantity

SELECT pizza_name, SUM(quantity) AS total_quantity_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity_sold ASC LIMIT 5;

-- 7. Top 5 pizzas by total_orders

SELECT pizza_name, COUNT(distinct order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC LIMIT 5;

-- 7. Bottom 5 pizzas by total_orders

SELECT pizza_name, COUNT(distinct order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC LIMIT 5;







