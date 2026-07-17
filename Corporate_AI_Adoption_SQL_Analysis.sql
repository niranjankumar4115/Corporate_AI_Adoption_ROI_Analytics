-- CORPORATE AI INVESTMENT & ROI ANALYTICAL QUERIES (PostgreSQL)
-- ====================================================================
-- QUERY 1: High-Level Global Market Capitalization & Returns
-- Returns overall totals and returns across the global landscape
SELECT
COUNT(DISTINCT company_id) AS total_companies_tracked,
SUM(ai_investment_usd)::numeric(18,2) AS total_global_investment,
SUM(total_financial_benefits)::numeric(18,2) AS gross_benefits,
SUM(net_business_benefit)::numeric(18,2) AS net_business_benefit,
(SUM(total_financial_benefits) / NULLIF(SUM(ai_investment_usd), 0) * 100)::numeric(5,2) AS aggregate_roi_percentage
FROM corporate_ai_adoption;

-- QUERY 2: Industry Performance Matrix
-- Identifies average maturity, ROI multipliers, and total deployments by sector
SELECT
industry,
COUNT(company_id) AS company_count,
ROUND(AVG(ai_maturity_score)::numeric, 2) AS average_maturity,
ROUND(AVG(ai_roi_multiplier)::numeric, 2) AS average_roi_multiplier,
SUM(deployment_count) AS total_deployments,
SUM(net_business_benefit)::numeric(18,2) AS total_net_benefit
FROM corporate_ai_adoption
GROUP BY industry
ORDER BY total_net_benefit DESC;

-- QUERY 3: Geographic AI Adoption & Training Efficiency
-- Explores whether higher employee training hours lead to higher maturity scores across countries
SELECT
country,
ROUND(AVG(employee_ai_training_hours)::numeric, 2) AS avg_training_hours,
ROUND(AVG(ai_maturity_score)::numeric, 2) AS avg_maturity_score,
ROUND((AVG(ai_maturity_score) / NULLIF(AVG(employee_ai_training_hours), 0))::numeric, 4) AS maturity_gain_per_training_hour
FROM corporate_ai_adoption
GROUP BY country
ORDER BY avg_maturity_score DESC;

-- QUERY 4: Identifying High Investment vs. Underperforming Segments (Laggards)
-- Pulls companies with investments > $10M and ROI multipliers below 0.50
SELECT
company_id,
industry,
country,
ai_investment_usd,
ai_roi_multiplier,
ai_maturity_score
FROM corporate_ai_adoption
WHERE ai_investment_usd > 10000000
AND ai_roi_multiplier < 0.50
ORDER BY ai_investment_usd DESC
LIMIT 10;

-- QUERY 5: Year-over-Year (YoY) Growth Trends in AI Capital Injection
-- Shows the YoY investment growth using window functions
WITH yearly_agg AS (
SELECT
year,
SUM(ai_investment_usd) AS total_investment
FROM corporate_ai_adoption
GROUP BY year
)
SELECT
year,
total_investment::numeric(18,2) AS current_year_investment,
LAG(total_investment) OVER (ORDER BY year)::numeric(18,2) AS prev_year_investment,
ROUND(
((total_investment - LAG(total_investment) OVER (ORDER BY year)) /
NULLIF(LAG(total_investment) OVER (ORDER BY year), 0) * 100)::numeric, 2
) AS yoy_growth_percentage
FROM yearly_agg
ORDER BY year;

-- QUERY 6: AI Adoption Tier Segmentation & Financial Value Models
-- Categorizes companies into discrete increments based on maturity scaling metrics
SELECT
FLOOR(ai_adoption_level * 10) / 10 AS adoption_tier_start,
(FLOOR(ai_adoption_level * 10) / 10) + 0.1 AS adoption_tier_end,
COUNT(DISTINCT company_id) AS company_count,
CONCAT(ROUND(AVG(automation_rate), 2), '%') AS avg_automation_rate,
CONCAT('$', TO_CHAR(ROUND(AVG(revenue_impact + cost_savings), 2), 'FM999,999,999')) AS avg_financial_impact_usd,
CONCAT(ROUND(AVG((revenue_impact + cost_savings) / NULLIF(ai_investment_usd, 0)), 2), '%') AS avg_roi
FROM polished_corporate_ai_adoption
GROUP BY
industry,
horizon,
adoption_tier_start,
adoption_tier_end
ORDER BY adoption_tier_start ASC
LIMIT 40;

-- QUERY 7: AI Adoption Industry metrics Summary
-- calculates industry-wide averages for AI investments, deployment metrics, costs, and
--  financial benefits, grouped by industry and time horizon.
SELECT
  industry,
  horizon,
  ROUND(AVG(ai_investment_usd), 0) AS avg_investment_usd,
  ROUND(AVG(deployment_count), 1) AS avg_deployment_count,
  ROUND(AVG(cost_per_deployment), 2) AS avg_cost_per_deployment, -- Fixed typo
  ROUND(AVG(total_financial_benefit), 0) AS avg_total_financial_benefit
FROM polished_corporate_ai_adoption
GROUP BY industry, horizon
ORDER BY industry, horizon DESC
LIMIT 10;