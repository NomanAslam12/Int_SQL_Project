WITH rev_percentile AS (
	SELECT	
		c.countryfull AS country,
		c.customerkey,
		ROUND(SUM(s.quantity * s.netprice / s.exchangerate)) AS total_revenue_USD,
		ntile(100) OVER (ORDER BY ROUND(SUM(s.quantity * s.netprice / s.exchangerate)) ASC) AS revenue_percentile
	FROM sales s
	JOIN customer c ON c.customerkey = s.customerkey 
	GROUP BY c.customerkey
),
percentile_category AS (
	SELECT 
		rp.*,
		CASE
			WHEN rp.revenue_percentile >= 67 THEN '1_HIGH'
			WHEN rp.revenue_percentile >= 34 THEN '2_MEDIUM'
			ELSE '3_LOW'
		END AS customer_category
	FROM rev_percentile rp
),
category_table AS (
SELECT 
	pc.country,
    pc.customer_category,
	count(*) AS category_count,
	SUM(count(*)) OVER (PARTITION BY pc.country ) AS total_customers_per_country,
	100 * (count(*) / SUM(count(*)) OVER (PARTITION BY pc.country ))AS category_percentage
FROM percentile_category pc
GROUP BY pc.country, pc.customer_category 
)	
SELECT 
	ct.country ,
	ct.customer_category,
	ct.category_count,
	ct.total_customers_per_country,
	ct.category_percentage
FROM category_table ct
ORDER BY 
	ct.country ,
	ct.customer_category;

/*
to check if the customer has more than 1 country or not 
SELECT customerkey, COUNT(DISTINCT countryfull)
FROM customer
GROUP BY customerkey
HAVING COUNT(DISTINCT countryfull) > 1;
*/

/* for checking the type after the calcualtions 
SELECT
    pg_typeof(COUNT(*)),
    pg_typeof(SUM(COUNT(*)) OVER ())
FROM sales
GROUP BY storekey
LIMIT 1;