WITH rfm_base AS (
    SELECT
        s.customerkey,
        COUNT(DISTINCT s.orderkey) AS order_frequency,
        SUM(s.quantity * s.netprice / s.exchangerate) AS total_revenue_usd,
        MAX(s.orderdate) AS latest_order_date,
        (SELECT MAX(orderdate) FROM sales) - MAX(s.orderdate) AS days_till_last_ordered
    FROM sales s
    GROUP BY s.customerkey
),
scored AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY days_till_last_ordered DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY order_frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY total_revenue_usd ASC) AS monetary_score
    FROM rfm_base
),
labeled AS (
    SELECT
        *,
        CASE
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
            WHEN recency_score <= 2 AND monetary_score >= 4 THEN 'At Risk (High Value)'
            WHEN recency_score <= 2 AND monetary_score <= 2 THEN 'Lost'
            WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'New/Low Frequency'
            ELSE 'Mid-Tier'
        END AS rfm_segment
    FROM scored
)
SELECT
    rfm_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_revenue_usd)) AS avg_ltv,
    ROUND(SUM(total_revenue_usd)) AS total_segment_revenue
FROM labeled
GROUP BY rfm_segment
ORDER BY total_segment_revenue DESC;