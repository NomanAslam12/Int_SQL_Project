
WITH rev_percentile AS (
    SELECT
        c.countryfull AS country,
        c.customerkey,
         SUM(s.quantity * s.netprice / s.exchangerate) AS total_revenue_usd,

        NTILE(100) OVER (
            ORDER BY SUM(s.quantity * s.netprice / s.exchangerate) ASC
        ) AS revenue_percentile

    FROM sales s
    JOIN customer c
        ON c.customerkey = s.customerkey

    GROUP BY
        c.customerkey,
        c.countryfull
),

percentile_category AS (
    SELECT
        rp.*,

        CASE
            WHEN revenue_percentile >= 67 THEN '1_HIGH'
            WHEN revenue_percentile >= 34 THEN '2_MEDIUM'
            ELSE '3_LOW'
        END AS customer_category

    FROM rev_percentile rp
),

category_table AS (
    SELECT
        country,
        customer_category,

        COUNT(*) AS category_count,

        SUM(total_revenue_usd) AS category_revenue,

        SUM(SUM(total_revenue_usd)) OVER (
            PARTITION BY country
        ) AS total_country_revenue

    FROM percentile_category

    GROUP BY
        country,
        customer_category
)

SELECT
    country,
    customer_category,
    category_count,
    category_revenue,
    total_country_revenue,
    100.0 * category_revenue / total_country_revenue   AS revenue_contribution_percentage

FROM category_table

ORDER BY
    country,
    customer_category;