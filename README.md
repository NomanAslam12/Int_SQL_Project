# Intermediate SQL - Sales Analysis

## Overview
Analysis of customer behavior, retention, and lifetime value for an e-commerce company to improve customer retention and maximize revenue.

## Business Questions
1. **Customer Segmentation Analysis:** Who are our most valuable customers?
2. **Cohort Analysis:** How do different customer groups generate revenue?
3. **Retention Analysis:** Which customers haven't purchased recently?
4. **RFM Analysis:** What does the current customer segmentation reveal?


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


### Deep Dive: Customer Segmentation by Country
To better understand regional differences, we analyzed how customers are distributed across value tiers *by country* — both in terms of **customer count** and **revenue contribution**.

#### A. Customer Distribution by Revenue Tier (% of Customers)
💻Query: [1_a_customer_segmentation](/Scripts/1_a_customer_segementation_by_revenue_tier.sql)

**📈Visualization:**
![Customer Distribution by Revenue Tier](/images/1_a_customer_segmentation_byrevenue_bycountry.png)

**Key Observations:**
- Low-value customers make up the largest share in most countries — ranging from 33% (US) to 49% (Australia)
- High-value customers represent only 17–33% of the customer base across all countries
- Australia has the smallest high-value customer share (17%) and the largest low-value share (49%), indicating a more price-sensitive market

#### B. Revenue Contribution by Tier (% of Total Revenue)
💻Query: [1_b_customer_segmentation](/Scripts/1_b_customer_segmentation_by_contribution_by_country.sql)

**📈Visualization:**
![Revenue Contribution by Country](/images/1_b_customer_seg_by_revenue_contribuitonTier_by_country.png)

**Key Observations:**
- Despite being a minority in *count*, High-value customers generate 55–81% of total revenue across countries
- Low-value customers contribute only 3–11% of revenue, despite being the largest group
- The UK and US show the strongest revenue concentration in the High-value tier (81% and 78% respectively), while Australia has the lowest concentration (55%)

#### Combined Country-Level Summary (Averages)

| Tier | % of Customers (Avg.) | % of Revenue (Avg.) |
|------|----------------------|----------------------|
| High | ~30%                 | ~73%                 |
| Mid  | ~31%                 | ~22%                 |
| Low  | ~39%                 | ~5%                  |

> **Takeaway:** Across all countries, the top ~30% of customers deliver ~73% of revenue, while the bottom ~40% contribute only ~5%. This reinforces the need for targeted retention and upsell strategies — especially in markets like Australia where the high-value base is thinner.

**💡Business Insights:**
- **High-value (66% revenue):** Offer premium membership program to 12,372 VIP customers, as losing one customer significantly impacts revenue
- **Mid-value (32% revenue):** Create upgrade paths through personalized promotions, with potential $66.6M to $135.4M revenue opportunity
- **Low-value (2% revenue):** Design re-engagement campaigns and price-sensitive promotions to increase purchase frequency
- **Regional nuance:** Prioritize high-value retention in the UK/US, while in Australia, focus on upgrading mid/low-tier customers to expand the high-value base

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

### 4. RFM Customer Segmentation (Recency, Frequency, Monetary)

**Business Question:** Which "high-value" customers, as defined by lifetime spend alone, are actually at risk of churning — a distinction our LTV-only segmentation can't make?

- Built Recency, Frequency, and Monetary scores per customer using `NTILE(5)` quintile bucketing, combined into a single RFM segment label via stacked CTEs
- Classified customers into five behavioral segments: Champions, At Risk (High Value), Mid-Tier, New/Low Frequency, and Lost

💻 Query: [4_rfm_segmentation.sql](/Scripts/4_rfm_segmentation.sql)
**📈Visualization:**
![RFM Analysis](/images/4_rfm_segmentation.png)
| Segment | Customers | % of Base | Total Revenue | % of Revenue | Avg. LTV |
|---|---|---|---|---|---|
| Champions | 7,493 | 15.1% | $68.2M | 33.1% | $9,098 |
| Mid-Tier | 20,461 | 41.3% | $64.5M | 31.3% | $3,151 |
| At Risk (High Value) | 6,878 | 13.9% | $56.9M | 27.6% | $8,274 |
| New/Low Frequency | 5,453 | 11.0% | $10.8M | 5.2% | $1,985 |
| Lost | 9,202 | 18.6% | $5.9M | 2.9% | $641 |

**📊 Key Findings:**
- **At Risk (High Value)** customers — 6,878 people (13.9% of the base) — represent **$56.9M in historical revenue (27.6% of total)**, but have gone quiet by recency. This segment is functionally invisible to LTV-only segmentation, which would classify most of them as "High Value" alongside genuinely active customers.
- **Champions** (7,493 customers, 15.1%) remain the healthiest segment: high spend, frequent, and recent — $68.2M (33.1% of revenue).
- Combined, Champions + At Risk make up just 27.9% of customers but 60.7% of all revenue — confirming extreme revenue concentration, but revealing that nearly half of that concentration is currently unstable.
- **Lost** customers (9,202, 18.6% of the base) contribute only 2.9% of revenue — low priority for retention spend.
- **Mid-Tier** (20,461 customers, 41.3% of the base) generates 31.3% of revenue — the largest single segment and a natural upgrade-path target.
- **New/Low Frequency** (5,453 customers, 11.0%) contribute 5.2% of revenue — recent buyers who haven't yet built purchase frequency.



**💡 Business Insights:**
- Prioritize a targeted win-back campaign specifically for the 6,878 At Risk (High Value) customers before they fully churn — this is a more precise target than a blanket "protect the top 25%" strategy, since it isolates the subset actually showing disengagement signals.
- Do not spend retention budget on the Lost segment — their revenue contribution doesn't justify reactivation cost; if pursued, use only low-cost automated win-back triggers, not account management.
- Mid-Tier is the natural upgrade-path target — the largest customer group with real spend, not yet Champion-tier frequency. Converting even a fraction of Mid-Tier to Champion behavior has outsized revenue impact given its size.
- Recommend layering RFM segments on top of the existing LTV-only tiers in future reporting — LTV alone cannot distinguish an active top spender from one who has already started to churn.


## Strategic Recommendations
Cross-referencing the four analyses surfaces a priority order, not just a list of ideas.

### Priority 1: Retention over acquisition
Cohort churn hits ~90% within 2-3 years across every cohort, including 2022-2023 — this isn't a bad-year problem, it's structural. Acquisition spend is currently refilling a bucket that leaks at a fixed rate. Before any acquisition budget increase, allocate spend to first-year onboarding: milestone-based incentives at day 30/90/180, since the retention curve shows the drop-off is front-loaded.

### Priority 2: Win back the 6,878 At Risk (High Value) accounts before they become Lost
RFM segmentation resolves what the earlier LTV-only segmentation couldn't show: of the ~12,372 customers previously grouped as "High Value," a meaningful share — 6,878 customers, holding **$56.9M in historical revenue (27.6% of total)** — have gone quiet by recency despite their spend history. This is the churn-rate number Priority 2 was previously missing. These accounts are not yet Lost, which makes them the highest-leverage retention target in the business: reactivating a customer who already trusts the brand and has a high spend ceiling costs far less than acquiring a new one at equivalent value.
- Target: move a defined percentage of the At Risk (High Value) segment back into Champions within two quarters, via account-level outreach or a named account manager for the top tier of this group — not a generic "premium membership" pitch.
- Deprioritize the Lost segment (9,202 customers, only 2.9% of revenue) for anything beyond low-cost automated win-back triggers — the revenue math doesn't justify account-level investment there.

### Priority 3: Diagnose why 2016-2018 cohorts outspent 2024 by ~40%
$2,800+ vs. ~$1,970 per customer is a large enough gap to be a product or market shift, not noise. Before designing a "loyalty program," pull what changed operationally between those cohorts — pricing, catalog, acquisition channel — or the loyalty program will be treating a symptom you haven't diagnosed.

### Priority 4: Correct for single-customer distortion in store-level performance reads
Daily revenue at physical stores is highly volatile — peak days run 10-20x the store's average — and the drill-down shows this is driven by single large-basket customer visits, not genuine demand spikes (peak days consistently show 1-3 unique customers, not a rise in traffic). Store-level staffing, inventory, and performance benchmarks should exclude whale-order outliers or use a trimmed/median daily figure instead of a raw average, which is currently overstating "typical" day-to-day expectations. This also reframes the online channel (store 999999): it sustains high revenue through broad customer volume rather than outlier transactions, making it the more stable and forecastle channel of the two.

### What's missing to make this actionable
- No CAC or margin data, so "acquisition is expensive relative to retention" is asserted, not shown. Add it if available.
- No time-bound targets anywhere in the doc beyond Priority 2's two-quarter window. "Improve retention" without a number and a deadline isn't a recommendation, it's an intention — Priorities 1 and 3 still need explicit targets once the underlying diagnostics are run.
- No margin/cost data behind the store-level whale-order finding (Priority 4) — the revenue distortion is confirmed, but whether these large-basket visits are also high-margin hasn't been checked.
