-- ============================================
-- SQL DATA ANALYSIS PRACTICE QUERIES
-- ============================================

-- Sample Tables:
-- customers(customer_id, customer_name, region)
-- orders(order_id, customer_id, order_date, amount)
-- sales(month, revenue)

-- --------------------------------------------
-- 1. INNER JOIN
-- --------------------------------------------

SELECT c.customer_id,
       c.customer_name,
       o.order_id,
       o.amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;


-- --------------------------------------------
-- 2. LEFT JOIN (Find customers with no orders)
-- --------------------------------------------

SELECT c.customer_id,
       c.customer_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- --------------------------------------------
-- 3. GROUP BY (Total revenue per customer)
-- --------------------------------------------

SELECT customer_id,
       SUM(amount) AS total_revenue
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC;


-- --------------------------------------------
-- 4. GROUP BY with COUNT (Orders per region)
-- --------------------------------------------

SELECT c.region,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.region;


-- --------------------------------------------
-- 5. RANK() (Top customers by revenue)
-- --------------------------------------------

SELECT customer_id,
       SUM(amount) AS total_revenue,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS revenue_rank
FROM orders
GROUP BY customer_id;


-- --------------------------------------------
-- 6. RANK() with PARTITION (Top customers per region)
-- --------------------------------------------

SELECT c.region,
       c.customer_id,
       SUM(o.amount) AS total_revenue,
       RANK() OVER (PARTITION BY c.region ORDER BY SUM(o.amount) DESC) AS regional_rank
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.region, c.customer_id;


-- --------------------------------------------
-- 7. LAG() (Month-over-month revenue comparison)
-- --------------------------------------------

SELECT month,
       revenue,
       LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
       revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_difference
FROM sales;


-- --------------------------------------------
-- 8. ROW_NUMBER() (Unique ranking)
-- --------------------------------------------

SELECT customer_id,
       SUM(amount) AS total_revenue,
       ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) AS row_num
FROM orders
GROUP BY customer_id;



------ADVANCED QUERIES-----

-- Second Highest Salary
SELECT MAX(salary)
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Running Total
SELECT month,
       revenue,
       SUM(revenue) OVER (ORDER BY month) AS running_total
FROM sales;

-- Top 3 Customers Per Region
SELECT *
FROM (
    SELECT region,
           customer_id,
           SUM(amount) AS total_spent,
           RANK() OVER (PARTITION BY region ORDER BY SUM(amount) DESC) AS rank
    FROM orders
    GROUP BY region, customer_id
) ranked
WHERE rank <= 3;