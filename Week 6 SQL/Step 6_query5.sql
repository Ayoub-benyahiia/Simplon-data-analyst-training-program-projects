SELECT dimCC.CptCode, SUM(FT.CPTUnits) AS "Total Units"
FROM FactTable FT
JOIN dimCptCode dimCC ON FT.dimCPTCodePK = dimCC.dimCPTCodePK
GROUP BY dimCC.CptCode
HAVING SUM(FT.CPTUnits) > 100;