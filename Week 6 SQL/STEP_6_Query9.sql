--Total adjustments
SELECT SUM(FT.Adjustment) AS "Total Credentialing Adjustments"
FROM FactTable FT
JOIN dimTransaction dimT
ON FT.dimTransactionPK = dimT.dimTransactionPK
WHERE dimT.TransactionType = 'Credentialing';

--Clinic with most adjustments
SELECT dimL.LocationName,
       SUM(FT.Adjustment) AS "Total Adjustments"
FROM FactTable FT
JOIN dimLocation dimL
ON FT.dimLocationPK = dimL.dimLocationPK
JOIN dimTransaction dimT
ON FT.dimTransactionPK = dimT.dimTransactionPK
WHERE dimT.TransactionType = 'Credentialing'
GROUP BY dimL.LocationName
ORDER BY "Total Adjustments" DESC;

--Doctors affected
SELECT COUNT(DISTINCT dimPhy.ProviderName) AS "Doctors Affected"
FROM FactTable FT
JOIN dimPhysician dimPhy
ON FT.dimPhysicianPK = dimPhy.dimPhysicianPK
JOIN dimTransaction dimT
ON FT.dimTransactionPK = dimT.dimTransactionPK
WHERE dimT.TransactionType = 'Credentialing';