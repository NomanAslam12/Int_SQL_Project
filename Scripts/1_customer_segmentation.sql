
WITH customer_ltv AS (
    SELECT 
        ca.customerkey,
        ca.clean_name,
        SUM(total_net_revenue) AS total_ltv
    FROM cohort_analysis ca
    GROUP BY 
        ca.customerkey,
        ca.clean_name 
),

segment AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS p25,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS p75
    FROM customer_ltv
),

segment_values AS ( 
    SELECT 
        c.*,
        CASE 
            WHEN c.total_ltv <= s.p25 THEN '1 - Low Value'
            WHEN c.total_ltv <= s.p75 THEN '2 - Mid Value'
            ELSE '3 - High Value'
        END AS customer_segment_per_ltv
    FROM customer_ltv c
    CROSS JOIN segment s
    WHERE c.total_ltv IS NOT NULL
)

SELECT 
    customer_segment_per_ltv,
    ROUND(SUM(total_ltv))::integer AS total_spending,
    COUNT(customerkey) AS customer_count,
    ROUND(AVG(total_ltv))::integer AS avg_ltv
FROM segment_values 
GROUP BY customer_segment_per_ltv 
ORDER BY customer_segment_per_ltv DESC;