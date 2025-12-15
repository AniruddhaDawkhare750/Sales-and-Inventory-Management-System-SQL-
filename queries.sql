USE Sales_and_Inventory_Management_System;

-- 1) Basic data & filters

-- a)List all products with category and price
SELECT p.product_id, p.product_name, c.category_name, p.sell_price 
FROM products p
JOIN  categories c
ON p.category_id=c.category_id;

-- b) How many sell in for every category
SELECT c.category_name, SUM(p.sell_price) 
FROM products p
JOIN  categories c
ON p.category_id=c.category_id
GROUP BY c.category_name;

-- c) List all customers in a specific city
SELECT customer_name FROM customers WHERE city='Mumbai';

-- d) List all customer who buys Personal care product
SELECT DISTINCT c.customer_name FROM customers c
JOIN sales s
ON c.customer_id=s.customer_id
JOIN sales_items si
ON s.sale_id=si.sale_id
JOIN products p
ON p.product_id=si.product_id
JOIN categories ca
ON ca.category_id=p.category_id
where ca.category_name='Personal Care';

-- e) Active products only
SELECT product_name FROM products WHERE is_active=1;

-- f) Products with selling price above 100
SELECT product_name,sell_price FROM products WHERE sell_price>100;

-- 2)Inventory-focused queries
-- a)Current stock of all products
SELECT p.product_name,i.stock FROM products p
JOIN inventory i
ON p.product_id=i.product_id;

-- b)Low-stock products (<= reorder level)
SELECT p.product_name FROM products p
JOIN inventory i
ON p.product_id=i.product_id
WHERE i.stock <= reorder_level;

SELECT * FROM inventory;
SELECT * FROM products;

-- c)Inventory value per product (stock × cost price)
SELECT p.product_name,(p.cost_price * i.stock) as total_value FROM products p
JOIN inventory i
ON p.product_id=i.product_id;

-- d)Total inventory value
SELECT SUM(p.cost_price * i.stock) as total_inventory_value FROM products p
JOIN inventory i
ON p.product_id=i.product_id;

-- e)Stock summary by category
SELECT c.category_id,c.category_name,count(p.product_id) FROM categories c
JOIN products p
ON p.category_id=c.category_id
GROUP BY c.category_id,c.category_name;

-- f)Reorder suggestion (order up to 2× reorder level)
-- for product do not run out of stock/have safe stock
SELECT p.product_name,i.stock,i.reorder_level,(2 * i.reorder_level - i.stock) as suggest_ordered
FROM inventory i
JOIN products p
ON p.product_id=i.product_id;

-- 3) Sales & revenue reports
-- a) Total revenue (all time)
SELECT * FROM sales_items;
SELECT SUM(quantity * unit_price) as total_revenue FROM sales_items;

-- b) Revenue per day
SELECT DATE(s.sale_date) as days,SUM(si.quantity * si.unit_price) as total_revenue FROM sales s
JOIN sales_items si
ON s.sale_id=si.sale_id
GROUP BY DATE(s.sale_date);

-- c)Revenue per month
SELECT DATE(YEAR(s.sale_date)) as months, SUM(si.quantity * si.unit_price) as total_revenue FROM sales s
JOIN sales_items si
ON s.sale_id=si.sale_id
GROUP BY DATE(YEAR(s.sale_date));

-- d) Revenue by category
SELECT c.category_name,SUM(si.quantity * si.unit_price) as revenue FROM sales s
JOIN sales_items si
ON s.sale_id=si.sale_id
JOIN products p
ON p.product_id=si.product_id
JOIN categories c
ON p.category_id=c.category_id
GROUP BY c.category_name;

-- e) Top 5 products by quantity 
SELECT p.product_name, COUNT(si.quantity) as count_item FROM products p
JOIN sales_items si
ON p.product_id=si.product_id
GROUP BY p.product_name
ORDER BY count_item desc
LIMIT 5; 

-- f) Top 5 products by revenue
SELECT p.product_name,SUM(si.quantity * si.unit_price) as revenue FROM products p
JOIN sales_items si
ON p.product_id=si.product_id
GROUP BY p.product_name
ORDER BY revenue
LIMIT 5;

-- g)Customer-wise total revenue
SELECT c.customer_name,SUM(si.quantity * si.unit_price) as revenue FROM customers c
JOIN sales s
ON s.customer_id=c.customer_id
JOIN sales_items si
ON s.sale_id=si.sale_id
GROUP BY c.customer_name
ORDER BY revenue DESC; 

-- h) Average order value 
SELECT AVG(quantity * unit_price) FROM sales_items;

-- i) List all invoices with total amount 
SELECT s.sale_id,s.sale_date,c.customer_name,c.city,
       SUM(si.quantity * si.unit_price) AS total_amount FROM sales s
		JOIN customers c ON s.customer_id = c.customer_id
		JOIN sales_items si ON s.sale_id = si.sale_id
		GROUP BY s.sale_id
        ORDER BY s.sale_date;

-- j) All orders for a given customer (e.g., Rahul Wavdhane)
SELECT s.sale_id,s.sale_date,c.customer_name,SUM(si.quantity * si.unit_price)as amount FROM sales s
JOIN customers c
ON c.customer_id=s.customer_id
JOIN sales_items si
ON s.sale_id=si.sale_id
WHERE c.customer_name='Rahul Wavdhane'
GROUP BY s.sale_id;

-- 4) Product performance & profit
-- a) Total profit per product (revenue – cost)
SELECT p.product_name,SUM(si.quantity * si.unit_price) as total_revenue FROM products p
JOIN sales_items si
ON p.product_id=si.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- b) Profit by category
SELECT c.category_name,(SUM(si.quantity * si.unit_price) - SUM(si.quantity * p.cost_price))as profit FROM categories c
JOIN products p
ON c.category_id=p.product_id
JOIN sales_items si
ON p.product_id=si.product_id
GROUP BY c.category_name;

-- c) Best selling category by quantity
SELECT c.category_name,SUM(si.quantity) as total_quantity FROM categories c
JOIN products p
ON c.category_id=p.category_id
JOIN sales_items si
ON p.product_id=si.product_id
GROUP BY c.category_name
ORDER BY total_quantity DESC;

-- 5)Customers & behaviour
-- a) Customers with no purchases (if any exist)
SELECT customer_name FROM customers c
WHERE customer_id not in (SELECT customer_id FROM sales);

-- b) New vs repeat customers
SELECT c.customer_name,COUNT(DISTINCT s.sale_id) as orders,
CASE WHEN COUNT(DISTINCT s.sale_id)=1 THEN 'NEW'
	WHEN COUNT(DISTINCT s.sale_id)>1 THEN 'REPEATE'
    END as type_of_customer
FROM customers c
JOIN sales s
ON c.customer_id=s.customer_id
GROUP BY c.customer_name;
    
-- c) Top customer in each city (MySQL 8 window function)
with a as( SELECT c.customer_name,c.city,
RANK() OVER(PARTITION BY c.city ORDER BY SUM(si.quantity * si.unit_price) DESC) as rn FROM customers c
JOIN sales s
ON c.customer_id=s.customer_id
JOIN sales_items si
ON s.sale_id=si.sale_id
GROUP BY c.customer_id)
SELECT * FROM a
WHERE rn=1;

-- 6) Time-series / window analytics
-- a) Cumulative revenue over time
SELECT DATE(s.sale_date),SUM(si.quantity * si.unit_price) as price,
SUM(SUM(si.quantity * si.unit_price)) OVER(ORDER BY DATE(s.sale_date)) as comulative_revenue
FROM sales s
JOIN sales_items si 
ON s.sale_id=si.sale_id
GROUP BY DATE(s.sale_date);

-- b) Compare daily revenue with previous day
SELECT DATE(s.sale_date),SUM(si.quantity*si.unit_price) as daily_revenue,
LAG(SUM(si.quantity*si.unit_price)) OVER (ORDER BY DATE(s.sale_date)) as previous_day, -- use LAG() for previous day 
SUM(si.quantity*si.unit_price) - LAG(SUM(si.quantity*si.unit_price)) OVER (ORDER BY DATE(s.sale_date)) as diff_pre  -- differnce between today - previous day 
FROM sales s
JOIN sales_items si 
ON s.sale_id=si.sale_id
GROUP BY DATE(s.sale_date);

-- c) Monthly growth percentage
SELECT DATE_FORMAT(s.sale_date,'%Y-%m') as months,SUM(si.quantity * si.unit_price) as revenue,
LAG(SUM(si.quantity * si.unit_price)) OVER(PARTITION BY DATE_FORMAT(s.sale_date,'%Y-%m')) as previous_month_rev,
ROUND((SUM(si.quantity * si.unit_price) - LAG(SUM(si.quantity * si.unit_price)) OVER(PARTITION BY DATE_FORMAT(s.sale_date,'%Y-%m')))/(LAG(SUM(si.quantity * si.unit_price)) OVER(PARTITION BY DATE_FORMAT(s.sale_date,'%Y-%m')))*100,2) as percentage
FROM sales s
JOIN sales_items si
ON s.sale_id=si.sale_id
GROUP BY DATE_FORMAT(s.sale_date,'%Y-%m');

-- 7) Maintenance / admin queries
-- a) Increase all snack category prices by 5%
SELECT product_id,product_name,sell_price,CEIL(ROUND((sell_price*1.05),2)) as increase_rate FROM products;

-- b) Mark products as inactive if stock is zero
SELECT p.product_name,if(i.stock=0,0,1)as stock_update FROM inventory i
JOIN products p
ON p.product_id=i.product_id;

-- c) Delete products never sold (careful!)
                 -- I does not delete it because database get disturbed
DELETE FROM products where(
SELECT p.product_name FROM products p
JOIN sales_items si
ON p.product_id=si.product_id
WHERE p.product_id NOT IN (SELECT sale_id FROM sales_items)); 

-- d) List products not sold in last 30 days
SELECT product_name FROM products p
JOIN sales_items si
ON p.product_id=si.product_id
JOIN sales s
ON s.sale_id=si.sale_id
WHERE MONTH(s.sale_date) >= CURRENT_TIMESTAMP -30 AND p.product_id NOT IN (SELECT sale_id FROM sales_items);

-- e) Find the last sale date of each product
with a as(SELECT p.product_name,DATE(s.sale_date),RANK() OVER(PARTITION BY p.product_name ORDER BY (CURRENT_TIMESTAMP()-DATE(s.sale_date))) as diff
FROM products p
JOIN sales_items si
ON p.product_id=si.product_id
JOIN sales s
ON s.sale_id=si.sale_id)
SELECT * FROM a
WHERE diff=1;

-- f) Top 3 products per category (by revenue)
with a as (SELECT p.product_name,c.category_name,RANK() OVER(PARTITION BY c.category_name ORDER BY(si.quantity * si.unit_price) DESC) as top_revenue FROM products p
JOIN sales_items si
ON p.product_id=si.product_id
JOIN categories c
ON p.category_id=c.category_id)
SELECT * FROM a
WHERE top_revenue<=3;