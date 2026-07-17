# . Segment Historical vs. Projected Horizons
df['horizon'] = np.where(df['year'] <= 2023, 'Historical (2015-2023)', 'Projected (2024-2035)')

# . Feature Engineering: Advanced Business Metrics
# Metric A: Return on Investment (ROI)
df['total_financial_benefit'] = df['revenue_impact'] + df['cost_savings']
df['ai_roi_multiplier'] = df['total_financial_benefit'] / df['ai_investment_usd']

# Metric B: Human Capital Efficiency Ratio (HCER)
# Measures how much AI Maturity is built per employee training hour
df['maturity_per_training_hour'] = df['ai_maturity_score'] / (df['employee_ai_training_hours'] + 1e-5)

# Metric C: Cost of Deployment
# Average capital invested per active deployment
df['cost_per_deployment'] = df['ai_investment_usd'] / (df['deployment_count'] + 1e-5)

# Save the polished analytical table
df.to_csv("polished_corporate_ai_adoption.csv", index=False)
print("ETL Pipeline Executed successfully. Data shape:", df.shape)
