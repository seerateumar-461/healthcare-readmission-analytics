"""
Healthcare Operations & Hospital Readmission ETL Pipeline
Author: Umar Farooq
"""

import os
import pandas as pd
import numpy as np
import sqlite3

def run_etl():
    raw_path = os.path.join("data", "raw", "hospital_admissions_raw.csv")
    cleaned_path = os.path.join("data", "cleaned", "hospital_admissions_cleaned.csv")
    dept_path = os.path.join("data", "cleaned", "department_capacity_metrics.csv")
    db_path = os.path.join("data", "healthcare.db")

    print("[ETL] Loading raw clinical admissions...")
    df = pd.read_csv(raw_path)

    df["AdmissionDate"] = pd.to_datetime(df["AdmissionDate"])
    df["DischargeDate"] = pd.to_datetime(df["DischargeDate"])
    df["AdmissionMonth"] = df["AdmissionDate"].dt.to_period("M").astype(str)

    df["ReadmissionRiskTier"] = pd.cut(
        df["ComorbidityIndex"] + (df["Age"] >= 65).astype(int),
        bins=[-1, 1, 3, 10],
        labels=["Low Risk", "Medium Risk", "High Risk"]
    )

    dept_metrics = df.groupby("Department").agg({
        "PatientID": "count",
        "LengthOfStay": "mean",
        "IsReadmitted30Days": ["sum", "mean"],
        "TotalTreatmentCost": ["sum", "mean"]
    }).round(2)
    dept_metrics.columns = ["TotalAdmissions", "AverageLengthOfStay", "TotalReadmissions", "ReadmissionRate", "TotalCost", "AvgCostPerPatient"]
    dept_metrics["ReadmissionRatePct"] = (dept_metrics["ReadmissionRate"] * 100).round(2)

    df.to_csv(cleaned_path, index=False)
    dept_metrics.reset_index().to_csv(dept_path, index=False)

    conn = sqlite3.connect(db_path)
    df.to_sql("admissions", conn, if_exists="replace", index=False)
    dept_metrics.reset_index().to_sql("department_kpis", conn, if_exists="replace", index=False)
    conn.close()

    print("[ETL] Healthcare pipeline completed successfully.")

if __name__ == "__main__":
    run_etl()
