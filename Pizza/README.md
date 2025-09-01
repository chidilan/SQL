# Pizza Sales Analysis (SQL)
## Table of Contents
<ul>

[1. About the project](#about-the-project)

[2. About the dataset](#about-the-dataset)

[3. Tools and libraries](#tools-and-libraries)

[4. Phases of the project](#phases-of-the-project)

<ul>

[4.1. Data Exploration](#1-data-exploration)

[4.2. Data Cleaning](#2-data-cleaning)

[4.3. Data Analysis and Key Insights](#3-data-analysis-and-key-insights)

</ul> </ul> <hr>

## __About the project__ ##

This project is a self-study analysis of pizza sales data.
The goal was to practice SQL for data aggregation, KPI calculations, and generating insights from sales data.

### Key objectives included: ###

1. Calculating overall revenue and order metrics

2. Identifying popular pizzas by quantity and revenue

3. Understanding trends by day, month, category, and size

4. Highlighting top-performing and low-performing items

<hr>

## __About the dataset__ ##

The dataset is stored in a MySQL database called pizza in a table named pizza_sales.

**<u>Key columns include:</u>**

* order_id → Unique order identifier

* order_date → Date of order

* pizza_name → Name of the pizza

* pizza_category → Category (e.g., Veggie, Classic, Supreme)

* pizza_size → Size of the pizza (Small, Medium, Large)

* quantity → Number of pizzas in the order

* total_price → Revenue from the order

<hr>

## __Tools and libraries__ ##

SQL (MySQL) → aggregation, KPI calculation, ranking, and grouping

<hr>

## __Phases of the project__ ##

## 1. Data Exploration ##

**Initial checks included:**

<ul>

Previewing all rows and columns

Inspecting data types and value distributions

Checking for missing or inconsistent data

</ul> <hr>

## 2. Data Cleaning ##

Steps applied:

<ul>

Ensured no duplicate orders

Verified total_price matches quantity × unit price

Standardized category and size names

</ul> <hr>

## 3. Data Analysis and Key Insights ##
<ul>

The 8 most important SQL results:

### 1. Total Revenue ###

<img src="visuals/TotalRevenue.png" alt="Total Revenue" width="400">

> The Total revenue from all pizza sales was $817,860.05

### 2. Average Order Value ###

<img src="visuals/Avg%20Order%20Value.png" alt="Average Order Value" width="400">

> The average amount spend by a customer was $38.31

### 3. Total Pizzas Sold ###

<img src="visuals/Total%20Pizza%20Sold.png" alt="Total Pizza Sold" width="400">

> The Total number of pizzas sold was 49,574 units

### 4. Average Pizzas per Order ###

<img src="visuals/Avg%20Pizza%20Order.png" alt="Average Pizza Ordered" width="300">

> For the total orders, the company had an average of 2 pizzas per order.

### 5. % of Sales by Pizza Category ###

<img src="visuals/percentage%20of%20sales%20by%20pizza%20category.png" alt="percentage of sales by pizza category" width="300">

> All the various pizzas contributed almost the same to the total revenue but the classic slightly sold more than the rest.

### 6. % of Sales by Pizza Size ###

<img src="visuals/percentage%20of%20sales%20by%20pizza%20size.png" alt="percentage of sales by pizza size" width="300">

> The Large Pizzas were ordered the highest with almost a 50% contribution. this means for every 2 pizzas that were ordered, we can almost be certain that one of them was a Large

### 7. Top 5 Pizzas by Revenue ###

<img src="visuals/Top%205%20pizzas%20by%20revenue.png" alt="Top 5 pizzas by revenue" width="300">

> The Thia Chicken Pizza tops with $43,434.25 closly followed by the Barbecue Chicken Pizza with $42,768 and in third place is The California Chicken Pizza with $41,409.5.

### 8. Top 5 Pizzas by Quantity Sold ###

<img src="visuals/Top%205%20pizzas%20by%20quantity.png" alt="Top 5 pizzas by quantity" width="300">

 > Again we see here that it was a close a battle in the top 5 race the top 4 all sold over 2400+ pizzas

</ul> <hr>

## Project Highlights ##

 * Comprehensive KPI calculation for revenue and order metrics

 * Category and size analysis to inform marketing and inventory decisions

 * Identification of top-performing pizzas for promotions and menu optimization

 * Prepared data for further visualizations and dashboards