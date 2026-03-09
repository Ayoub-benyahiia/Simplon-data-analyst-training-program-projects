SELECT COUNT(DISTINCT dimPhy.ProviderName) AS "Physicians with Medicare Claims"

FROM FactTable FT
JOIN dimPhysician dimPhy  ON FT.dimPhysicianPK = dimPhy.dimPhysicianPK
JOIN dimPayer dimPr ON FT.dimPayerPK = dimPr.dimPayerPK

WHERE dimPr.PayerName = 'Medicare';