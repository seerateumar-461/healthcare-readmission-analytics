# Tableau & Power BI Dashboard Blueprint: Healthcare Operations

## 1. Data Source Connections
* Connect to `data/healthcare.db` or load `data/cleaned/hospital_admissions_cleaned.csv`.

---

## 2. Calculated Fields (Tableau / Power BI DAX)

```tableau
// 1. 30-Day Readmission Flag
IF [IsReadmitted30Days] = 1 THEN "Readmitted (<30d)" ELSE "No Readmission" END

// 2. Excess Length of Stay (vs Target ALOS of 4.5 days)
[LengthOfStay] - 4.5

// 3. Bed Occupancy Cost per Day
[TotalTreatmentCost] / [LengthOfStay]

// 4. Clinical Risk Score Category
IF [ComorbidityIndex] >= 3 AND [Age] >= 65 THEN "Critical High Risk"
ELSEIF [ComorbidityIndex] >= 2 THEN "Moderate Risk"
ELSE "Standard Risk"
END
```

---

## 3. Executive Dashboard Structure
* **Top KPIs:** Total Patient Admissions (12,000), Overall 30-Day Readmit Rate (16.4%), Average ALOS (4.8 days), Total Spend (\$94.2M).
* **Charts:** Department Readmission Heatmap, Length of Stay Boxplots by Diagnosis, Risk Tier Exposure Tree.
