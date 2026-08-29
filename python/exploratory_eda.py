"""
Healthcare Exploratory Data Analysis & Visualizations
Author: Umar Farooq
"""

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def generate_eda_charts():
    df = pd.read_csv(os.path.join("data", "cleaned", "hospital_admissions_cleaned.csv"))
    os.makedirs(os.path.join("tableau", "visuals"), exist_ok=True)
    plt.style.use("seaborn-v0_8-whitegrid")

    fig, axes = plt.subplots(1, 2, figsize=(14, 5))
    dept_summary = df.groupby("Department")["IsReadmitted30Days"].mean() * 100
    sns.barplot(x=dept_summary.values, y=dept_summary.index, palette="mako", ax=axes[0], hue=dept_summary.index, legend=False)
    axes[0].set_title("30-Day Readmission Rate by Department (%)", fontsize=12, fontweight="bold")
    axes[0].set_xlabel("Readmission Rate (%)")

    sns.boxplot(x="ReadmissionRiskTier", y="TotalTreatmentCost", data=df, palette="Set2", ax=axes[1], hue="ReadmissionRiskTier", legend=False)
    axes[1].set_title("Treatment Cost Distribution by Risk Tier ($)", fontsize=12, fontweight="bold")
    axes[1].set_ylabel("Treatment Cost ($)")
    plt.tight_layout()
    fig.savefig(os.path.join("tableau", "visuals", "healthcare_kpi_summary.png"), dpi=200)
    plt.close()

    print("[EDA] Visual charts generated in tableau/visuals/")

if __name__ == "__main__":
    generate_eda_charts()
