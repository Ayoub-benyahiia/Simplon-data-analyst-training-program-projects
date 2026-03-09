-- 1. Patient information
SELECT 
    FT.PatientNumber,
    dimP.FirstName,
    dimP.LastName,
    dimP.PatientAge,
    dimP.PatientGender
FROM FactTable FT
JOIN dimPatient dimP ON FT.dimPatientPK = dimP.dimPatientPK
WHERE FT.PatientNumber = '100';


-- 2. Location and dates of service
SELECT 
    FT.PatientNumber,
    dimL.LocationName AS Clinic_Name,
    dimD.Date AS Service_Date
FROM FactTable FT
JOIN dimLocation dimL ON FT.dimLocationPK = dimL.dimLocationPK
JOIN dimDate dimD ON FT.dimDateServicePK = dimD.dimDatePostPK
WHERE FT.PatientNumber = '100';


-- 3. Information on doctors and charges
SELECT 
    FT.PatientNumber,
    dimPhy.ProviderName AS Doctor_Name,
    dimPhy.ProviderSpecialty AS Specialty,
    FT.GrossCharge
FROM FactTable FT
JOIN dimPhysician dimPhy ON FT.dimPhysicianPK = dimPhy.dimPhysicianPK
WHERE FT.PatientNumber = '100';


-- 4. Diagnostic codes and CPT codes
SELECT 
    FT.PatientNumber,
    dimDC.DiagnosisCodeDescription AS Illness,
    dimCC.CptDesc AS Treatment
FROM FactTable FT
JOIN dimDiagnosisCode dimDC ON FT.dimDiagnosisCodePK = dimDC.dimDiagnosisCodePK
JOIN dimCptCode dimCC ON FT.dimCPTCodePK = dimCC.dimCPTCodePK
WHERE FT.PatientNumber = '100';


-- 5. Transactions, payments and adjustments
SELECT 
    FT.PatientNumber,
    dimT.TransactionType,
    FT.Payment,
    FT.Adjustment,
    FT.AR
FROM FactTable FT
JOIN dimTransaction dimT ON FT.dimTransactionPK = dimT.dimTransactionPK
WHERE FT.PatientNumber = '100';