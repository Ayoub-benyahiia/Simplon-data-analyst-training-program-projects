SELECT SUM(FT.CPTUnits) AS "Total CPT Units"
FROM FactTable FT
JOIN dimDiagnosisCode dimDC
ON FT.dimDiagnosisCodePK = dimDC.dimDiagnosisCodePK
WHERE dimDC.DiagnosisCode LIKE 'J%';