// =============================================================================
// Power Query M Script: Clinical Admissions Data Pipeline
// =============================================================================
let
    Source = Csv.Document(File.Contents("data/cleaned/hospital_admissions_cleaned.csv"), [Delimiter=",", Columns=14, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{
        {"PatientID", type text},
        {"Age", Int64.Type},
        {"Gender", type text},
        {"Department", type text},
        {"PrimaryDiagnosis", type text},
        {"ComorbidityIndex", Int64.Type},
        {"AdmissionDate", type date},
        {"DischargeDate", type date},
        {"LengthOfStay", Int64.Type},
        {"TotalTreatmentCost", type number},
        {"IsReadmitted30Days", Int64.Type},
        {"ReadmissionGapDays", type number},
        {"AdmissionMonth", type text},
        {"ReadmissionRiskTier", type text}
    })
in
    #"Changed Type"
