# Intermediate SQL - Sales Analysis

## Overview
Analysis of customer behavior, retention, and lifetime value for an e-commerce company to improve customer retention and maximize revenue.

## Business Questions
1. **Customer Segmentation Analysis:** Who are our most valuable customers?
2. **Cohort Analysis:** How do different customer groups generate revenue?
3. **Retention Analysis:** Which customers haven't purchased recently?


## Analysis Approach

### 1. Customer Segmentation Analysis
- Categorized customers based on total life time value (LTV)
- Assigned customers to High, Mid and Low - value segments based on percentiles
- Calculated key metrics: total revenue

💻Query: [1_customer_segmentation](/Scripts/1_customer_segmentation.sql)

**📈Visualization:**
![Customer Segmentation](/images/1_customer_segmentation.png)

**📊Key Findings:**
- High Value segment (25% of customers) drives 66% of revenue ($135.4M)
- Mid-value segment (50% of customers) generates 32% of revenue ($66.6M)
- Low-value segment (25% of customers) account for 2% of revenue ($4.3M)

**💡Business Insights:**
- High-value (66% revenue): Offer premium membership program to 12,372 VIP customers, as losing one customer significantly impacts revenue
- Mid-value (32% revenue): Create upgrade paths through the personalized promotions, with potential $66.6M to $135.4M revenue opportunity
- Low-value (2% revenue): Design re-engagement campaigns and price-sensitive promotions to increase purchase frequency



### 2. Cohort Analysis
- Tracked revenue and customer count per cohorts
- Cohorts were grouped by year of first purchase
- Analyzed customer retention at a cohort level

💻Query: [2_cohort_analysis.sql](/Scripts/2_cohort_analysis.sql)

**📈Visualization:**
![Cohort Analysis](/images/2_cohort_analysis.png)

**📊Key Findings:**
- Customer revenue is declining, older cohorts (2016-2018) spent ~$2,800+, while 2024 cohort spending dropped to ~$1,970.
- Revenue and customers peaked in 2022-2023, but both are now trending downward in 2024.
- High volatility in revenue and customer count, with sharp drops in 2020 and 2024, signaling retention challenges.

**💡Business Insights**
- Boost retention & re-engagement by targeting recent cohorts (2022-2024) with personalized offers to prevent churn.
- Stabilize revenue fluctuations and introduce loyalty programs or subscriptions to ensure consistent spending.
- Investigate cohort differences by applying successful strategies from high-spending cohorts (2016-2018) to newer ones.

### 3. Customer Retention

💻Query: [3_retention_analysis.sql](/Scripts/3_retention_analysis.sql)

**📈Visualization:**
![Retention Analysis](/images/3_customer_retention.png)

**📊Key Findings:**
- Cohort churn stabilizes at ~90% after 2-3 years, indicating a predictable long term retention pattern.
- Retention rates are consistently low (8-11%) across all cohorts, suggesting retention issues are systematic rather than specific to certain years.
- Newer cohorts (2022-2023) show similar churn trajectories, signaling that without intervention future cohorts will follow the same pattern.

**💡Business Insights**
- Strengthen early engagement strategies to target the first 1-2 years with onboarding incentives, loyalty rewards, and personalized offers to improve long-term retention.
- Re-engage high-value churned customers by focusing on targeted win-back campaigns rather than broad retention efforts, as reactivating valuable users may yield higher ROI.
- Predict & preempt churn risk and use customer specific warning indicators to proactively intervene with at-risk users before they elapse.

## Strategic Recommendations

Cross-referencing the three analyses surfaces a priority order, not just a list of ideas.

### Priority 1: Retention over acquisition
Cohort churn hits ~90% within 2-3 years across every cohort, including 2022-2023 this isn't a bad-year problem, it's structural. Acquisition spend is currently refilling a bucket that leaks at a fixed rate. Before any acquisition budget increase, allocate spend to first-year onboarding: milestone-based incentives at day 30/90/180, since the retention curve shows the drop-off is front-loaded.

### Priority 2: Concentrate protection on the 12,372 high-value accounts
This segment covers 66% of revenue ($135.4M) on 25% of customers the revenue-per-customer ratio means churn here isn't replaceable by volume elsewhere. Set a specific target: reduce high-value churn rate by X% (pull the actual current churn rate for this segment specifically it isn't in the doc yet) via account-level monitoring and a named account manager or equivalent, not a generic "premium membership."

### Priority 3: Diagnose why 2016-2018 cohorts outspent 2024 by ~40%
$2,800+ vs. ~$1,970 per customer is a large enough gap to be a product or market shift, not noise. Before designing a "loyalty program," pull what changed operationally between those cohorts pricing, catalog, acquisition channel or the loyalty program will be treating a symptom you haven't diagnosed.

### What's missing to make this actionable
- No churn rate is reported *specifically for the high-value segment* that number should drive Priority 2's target.
- No CAC or margin data, so "acquisition is expensive relative to retention" is asserted, not shown. Add it if available.
- No time-bound targets anywhere in the doc. "Improve retention" without a number and a deadline isn't a recommendation, it's an intention.

## Technical Details
- **Database:** PostgreSQL
- **Analysis Tool:** PostgreSQL
- **Visualization:** Gemini and Excel