-- =============================================================================
-- Healthcare Operations & Readmissions Database Schema
-- Author: Umar Farooq
-- =============================================================================

DROP TABLE IF EXISTS admissions;
DROP TABLE IF EXISTS department_kpis;

CREATE TABLE admissions (
    PatientID VARCHAR(20) NOT NULL,
    Age INTEGER NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    PrimaryDiagnosis VARCHAR(100) NOT NULL,
    ComorbidityIndex INTEGER NOT NULL,
    AdmissionDate DATE NOT NULL,
    DischargeDate DATE NOT NULL,
    LengthOfStay INTEGER NOT NULL,
    TotalTreatmentCost NUMERIC(10, 2) NOT NULL,
    IsReadmitted30Days INTEGER NOT NULL,
    ReadmissionGapDays NUMERIC(5, 1),
    AdmissionMonth VARCHAR(7),
    ReadmissionRiskTier VARCHAR(20)
);

CREATE INDEX idx_adm_dept ON admissions(Department);
CREATE INDEX idx_adm_patient ON admissions(PatientID);
CREATE INDEX idx_adm_readmit ON admissions(IsReadmitted30Days);
