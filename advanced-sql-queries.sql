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