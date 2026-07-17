# Corporate AI Adoption Analytics

Corporate AI investment & ROI analytics · Python → PostgreSQL → Power BI · 8,000 global companies · 7 SQL queries · investment, maturity & ROI insights

## Overview

This project analyzes a global dataset of corporate AI adoption to uncover how investment, employee training, and deployment activity translate into measurable financial returns. The pipeline moves raw company-level data through Python-based cleaning and feature engineering, into PostgreSQL for analytical querying, and finally into a Power BI dashboard for interactive exploration.

The end goal is to answer a set of core business questions:
- How much is being invested in AI globally, and what is the aggregate return?
- Which industries and countries are getting the most value from AI adoption?
- Where is investment training hours actually driving maturity gains, and where is it not?
- Which companies are high spenders but low performers ("laggards")?
- How is AI investment trending year over year?

## Tech Stack

| Layer | Tools |
|---|---|
| Data Cleaning & EDA | Python (Pandas, NumPy, Matplotlib, Seaborn) |
| Feature Engineering | Python (Pandas, NumPy) |
| Database & Querying | PostgreSQL (CTEs, Window Functions, Aggregations) |
| Visualization | Power BI |

## Project Structure

```
├── data_cleaning_eda.py                     # Data loading, missing value checks, summary stats, EDA
├── Feature_engineering.py                   # Derived metrics: ROI, HCER, cost per deployment, horizon tagging
├── Corporate_AI_Adoption_SQL_Analysis.sql    # 7 analytical PostgreSQL queries
├── ai_adoption_dashboard.pbix                # Power BI dashboard
└── README.md
```

## Dataset Overview

The dataset tracks AI adoption at the company level across industries, countries, and years, covering investment, deployment, training, and financial outcome metrics.

| Feature | Description |
|---|---|
| `company_id` | Unique company identifier |
| `industry` | Sector the company operates in |
| `country` | Company headquarters location |
| `year` | Reporting year |
| `ai_investment_usd` | Capital invested in AI initiatives |
| `ai_maturity_score` | Score (0–10) representing AI adoption maturity |
| `ai_adoption_level` | Normalized adoption level used for tier segmentation |
| `employee_ai_training_hours` | Average AI-related training hours per employee |
| `deployment_count` | Number of active AI deployments |
| `automation_rate` | Share of processes automated via AI |
| `revenue_impact` / `cost_savings` | Financial benefit components |
| ➕ `total_financial_benefit` | `revenue_impact + cost_savings` |
| ➕ `ai_roi_multiplier` | `total_financial_benefit / ai_investment_usd` |
| ➕ `maturity_per_training_hour` | AI maturity built per training hour |
| ➕ `cost_per_deployment` | `ai_investment_usd / deployment_count` |
| ➕ `horizon` | `Historical (2015-2023)` vs `Projected (2024-2035)` |

## Workflow

**1. Data Cleaning & EDA** (`data_cleaning_eda.py`)
Loads the raw CSV, inspects data types and missing values, generates summary statistics, and profiles the distribution of companies by industry and country.

**2. Feature Engineering** (`Feature_engineering.py`)
Builds the analytical table used for downstream querying by deriving:
- **ROI Multiplier** – total financial benefit relative to investment
- **Human Capital Efficiency Ratio (HCER)** – maturity gained per training hour
- **Cost per Deployment** – capital efficiency of each AI deployment
- **Horizon segmentation** – splits records into historical (2015–2023) and projected (2024–2035) periods

The output is saved as `polished_corporate_ai_adoption.csv`, which feeds the industry/horizon-level SQL queries.

**3. SQL Analysis** (`Corporate_AI_Adoption_SQL_Analysis.sql`)
Seven PostgreSQL queries covering global aggregation, industry benchmarking, geographic training efficiency, outlier detection, YoY growth (via `LAG`/`OVER`), and tier-based segmentation with `GROUP BY`/`GROUPING`-style rollups.

**4. Dashboard** (`ai_adoption_dashboard.pbix`)
A Power BI dashboard built on the polished dataset for interactive, visual exploration of the findings below.

## Key Insights

**Global Portfolio Synthesis (Query 1)**
Across 8,000 unique corporate entities, $974.11B in global AI investment generated $944.18B in gross financial benefits — an aggregate global ROI of 96.93%.

**Industry Performance Modeling (Query 2)**
Technology emerged as the standout performer, generating $111.60B in net benefits at a 1.31x average ROI multiplier. Manufacturing lagged behind, posting a $33.97B net loss at a 0.64x average ROI multiplier — highlighting a sharp divide in AI payoff across sectors.

**Geographic Training Analytics (Query 3)**
The United States led globally on AI maturity (6.60/10 average score), backed by the highest training intensity at 92.03 average employee training hours — suggesting a strong link between sustained training investment and maturity outcomes.

**Risk & Outlier Segment Filtering (Query 4)**
548 companies were flagged as high-capital "laggards" — organizations investing over $10M in AI while producing a sub-0.50x ROI multiplier — representing a clear target list for internal process improvement audits.

**Time-Series Growth Analysis (Query 5)**
Using `LAG()` window functions over yearly aggregates, YoY AI investment growth ranged from 3.8% to 9.9% across the historical timeline, pointing to consistent (if uneven) expansion in corporate AI capital allocation.

**Adoption Tier & Horizon Segmentation (Queries 6–7)**
Companies were bucketed into 0.1-wide AI adoption tiers and further split by industry and time horizon (historical vs. projected), enabling comparison of automation rate, average financial impact, and ROI across maturity bands and forward-looking projections.

## How to Reproduce

1. Run `data_cleaning_eda.py` to inspect and clean the raw dataset.
2. Run `Feature_engineering.py` to generate `polished_corporate_ai_adoption.csv`.
3. Load both the raw and polished tables into PostgreSQL as `corporate_ai_adoption` and `polished_corporate_ai_adoption`.
4. Execute the queries in `Corporate_AI_Adoption_SQL_Analysis.sql`.
5. Open `ai_adoption_dashboard.pbix` in Power BI to explore the results interactively.

## Conclusion

This analysis shows that global AI investment is, on average, roughly breaking even in the near term (96.93% aggregate ROI) — but that average masks wide variance: Technology-sector adopters are compounding strong returns while Manufacturing and a distinct cluster of high-capital laggards are actively destroying value. Training investment appears to be a meaningful lever for maturity, with the US case standing out as a benchmark. These findings point toward a more targeted AI investment strategy: double down on high-ROI sectors, audit high-spend/low-return outliers, and treat employee training as a core driver of adoption maturity rather than a peripheral cost.
