-- Walmart Sales Analysis
-- 10 Business Problems Answered

SELECT *
FROM walmart

-- 1) Find no of transactions and no of quantites sold by each payment method

SELECT payment_method,
	   SUM(quantity) AS total_quantity,
	   COUNT(invoice_id) AS no_of_transactions
FROM walmart
GROUP BY payment_method

-- 2) Identify the highest rated category in each branch, displaying the 
--     branch,category,avg_rating 

SELECT *
FROM( 
	SELECT	
       branch,
       category,
	   AVG(rating) AS avg_rating,
	   RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
FROM walmart
GROUP BY 1,2
) 
WHERE rank=1

-- 3) Identify the busiest day for each branch based on the number of transactions

SELECT *
FROM
(
SELECT branch,
       TO_CHAR(TO_DATE(date,'DD/MM/YY'),'Day') AS day_name,
       COUNT(*) AS no_of_transactions,
	   RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
FROM walmart
GROUP BY 1,2
)
WHERE rank=1

-- 4) Calculate the total quantity of items sold per payment method .List payment method
--    and total quantity.

SELECT payment_method,
       SUM(quantity) AS total_quantity
FROM walmart
GROUP BY payment_method

-- 5) Determine avg, min, max rating of products for each city.
--    List the city, avg, min, max.

SELECT city,
       category,
       AVG(rating) AS avg_rating,
	   MIN(rating) AS min_rating,
	   MAX(rating) AS max_rating
FROM walmart
GROUP BY 1,2

-- 6) Calculate the total profit for each  category by considering total_profit as
--    (unit_price * quantity * margin) List category and total profit,ordered from highest to
--    to lowest profit.

SELECT category,
       SUM(total * profit_margin) AS total_profit
FROM walmart
GROUP BY 1
ORDER BY 2 DESC

-- 7) Determine the most common payment method for each branch. Display branch and the preferred 
--    payment method.

SELECT *
FROM (
SELECT branch,
       payment_method,
	   COUNT(*),
	   RANK() OVER(PARTITION BY branch ORDER BY(COUNT(*)) DESC) AS rank
FROM walmart
GROUP BY 1,2
ORDER BY 1
)
WHERE rank=1

-- 8) Categorize sales into 3 groups morning, afternoon, evening.
--    Find out each of the shift and no of invoices.

SELECT branch,
CASE
	WHEN EXTRACT(HOUR FROM (time::time)) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1,2
ORDER BY 1,3 DESC



		
