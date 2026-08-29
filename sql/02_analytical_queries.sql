-- =============================================================================
-- Advanced Healthcare SQL Queries: Readmission & Operational Efficiency
-- Author: Umar Farooq
-- Concepts: Window Functions (LEAD, AVG OVER PARTITION), CTEs, Case Logic
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Departmental ALOS vs Hospital-Wide Benchmark & Readmission Rates
-- -----------------------------------------------------------------------------
SELECT 
    Department,
    COUNT(*) AS total_admissions,
    ROUND(AVG(LengthOfStay), 2) AS dept_alos_days,
    ROUND(AVG(AVG(LengthOfStay)) OVER (), 2) AS hospital_wide_alos_days,
    ROUND(AVG(LengthOfStay) - AVG(AVG(LengthOfStay)) OVER (), 2) AS variance_from_hospital_alos,
    SUM(IsReadmitted30Days) AS total_readmissions,
    ROUND(AVG(IsReadmitted30Days) * 100.0, 2) AS readmission_rate_pct,
    ROUND(SUM(TotalTreatmentCost), 2) AS total_expenditure
FROM admissions
GROUP BY Department
ORDER BY readmission_rate_pct DESC;

-- -----------------------------------------------------------------------------
-- 2. Top Diagnoses Driving Readmissions with DENSE_RANK()
-- -----------------------------------------------------------------------------
WITH diagnosis_readmissions AS (
    SELECT 
        Department,
        PrimaryDiagnosis,
        COUNT(*) AS total_cases,
        SUM(IsReadmitted30Days) AS readmitted_cases,
        ROUND(AVG(IsReadmitted30Days) * 100.0, 2) AS readmission_rate_pct,
        ROUND(AVG(TotalTreatmentCost), 2) AS avg_cost
    FROM admissions
    GROUP BY Department, PrimaryDiagnosis
    HAVING COUNT(*) >= 50
),
ranked_diagnoses AS (
    SELECT 
        Department,
        PrimaryDiagnosis,
        total_cases,
        readmitted_cases,
        readmission_rate_pct,
        avg_cost,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY readmission_rate_pct DESC) AS dept_rank
    FROM diagnosis_readmissions
)
SELECT *
FROM ranked_diagnoses
WHERE dept_rank <= 2
ORDER BY Department, dept_rank;

-- -----------------------------------------------------------------------------
-- 3. Readmission Penalty Financial Exposure View
-- -----------------------------------------------------------------------------
CREATE VIEW IF NOT EXISTS v_readmission_financial_exposure AS
SELECT 
    Department,
    ReadmissionRiskTier,
    COUNT(*) AS patient_volume,
    SUM(IsReadmitted30Days) AS readmissions_count,
    ROUND(AVG(IsReadmitted30Days) * 100.0, 2) AS readmission_rate_pct,
    ROUND(SUM(CASE WHEN IsReadmitted30Days = 1 THEN TotalTreatmentCost * 0.35 ELSE 0 END), 2) AS estimated_penalty_exposure
FROM admissions
GROUP BY Department, ReadmissionRiskTier
ORDER BY estimated_penalty_exposure DESC;
