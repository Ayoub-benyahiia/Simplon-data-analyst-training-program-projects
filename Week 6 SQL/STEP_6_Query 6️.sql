--Medical specialty that received the most payments
SELECT dimPhy.ProviderSpecialty,
       SUM(FT.Payment) AS "Total Payments"
FROM FactTable FT
JOIN dimPhysician dimPhy
ON FT.dimPhysicianPK = dimPhy.dimPhysicianPK
GROUP BY dimPhy.ProviderSpecialty
ORDER BY "Total Payments" ASC;