WITH last_purchase AS (
	SELECT
		ca.customerkey,
		ca.orderdate,
		ca.clean_name ,
		row_number() OVER (PARTITION BY ca.customerkey ORDER BY orderdate DESC) AS rn,
		ca.first_purchase_date ,
		ca.cohort_year
	FROM cohort_analysis ca
),
churned_customers AS (
	SELECT
		customerkey ,
		clean_name,
		orderdate AS last_purchase_date,
		CASE 
			WHEN orderdate < (SELECT MAX(orderdate) FROM sales)::date - INTERVAL	'6 months' THEN 'Churned'
			ELSE 'Active'
		END AS customer_status,
		cohort_year 
	FROM last_purchase 
	WHERE rn = 1
		AND first_purchase_date < (SELECT MAX(orderdate) FROM sales)::date
)

SELECT 
	cohort_year,
	customer_status,
	COUNT(customerkey) AS num_customers,
	SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year) AS total_customers,
	ROUND(COUNT(customerkey) / SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year),2) AS status_percentage
FROM churned_customers cs
GROUP BY cs.cohort_year , cs.customer_status