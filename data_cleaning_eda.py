import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the dataset
# (Replace with your actual path or local file name)
df = pd.read_csv("F:/eda/corporate_ai_adoption_dataset - Copy.csv")


print("--- DATA TYPES & MISSING VALUES ---")
print(df.info())

print("\n--- MISSING VALUE COUNT ---")
print(df.isnull().sum())

#  Summary statistics for numerical columns
print("--- SUMMARY STATISTICS ---")
print(df.describe().T)

#  Categorical breakdown (Distribution of companies by Industry & Country)
print("\n--- MARKET SECTOR DISTRIBUTION ---")
print(df['industry'].value_counts(normalize=True) * 100)

print("\n--- GEOGRAPHIC DISTRIBUTION ---")
print(df['country'].value_counts().head(10))

# Clean Column Names (Strip whitespace if any)
df.columns = df.columns.str.strip()
