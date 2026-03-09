SELECT CptGrouping,
       COUNT(CptCode) AS "Number of CPT Codes"
FROM dimCptCode
GROUP BY CptGrouping
ORDER BY "Number of CPT Codes" DESC;