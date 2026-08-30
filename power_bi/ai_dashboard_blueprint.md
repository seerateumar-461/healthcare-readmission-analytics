# 🤖 Power BI AI-Driven Dashboard Blueprint: Healthcare Operations

---

## 1. 🧠 Key Influencers Visual (Readmission Driver Analysis)
* **Analyze:** `[Readmission Status Label]` = *"Readmitted (<30 Days)"*
* **Explain By:**
  * `hospital_admissions_cleaned[ComorbidityIndex]`
  * `hospital_admissions_cleaned[Age]`
  * `hospital_admissions_cleaned[LengthOfStay]`
  * `hospital_admissions_cleaned[Department]`
  * `hospital_admissions_cleaned[PrimaryDiagnosis]`
* **AI Output:**
  * Patients with **Comorbidity Index $\ge 3$** are **4.1x more likely** to be readmitted.
  * Patients aged **$\ge 65$** with ALOS $>7$ days have a **2.6x elevated risk**.

---

## 2. 🌳 Decomposition Tree (Root-Cause Hospital Readmission Drilldown)
* **Analyze:** `[Total Readmissions]`
* **Explain By:** `Department` $ightarrow$ `PrimaryDiagnosis` $ightarrow$ `ReadmissionRiskTier`
* **AI Split:** Select "High Value" to pinpoint top penalty-causing clinical pathways.

---

## 3. 📈 Anomaly Detection on Admission Volumes
* Line chart tracking monthly emergency intake with sensitivity bands flagging surge months.
