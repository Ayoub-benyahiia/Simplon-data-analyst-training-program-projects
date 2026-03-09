SELECT  
    dimP.FirstName + ' ' + dimP.LastName AS [Full Name],  
    dimP.Email,  
    dimP.PatientAge,  
    dimP.City,  
    dimP.State,  
    CASE  
        WHEN dimP.PatientAge < 18 THEN 'Under 18'  
        WHEN dimP.PatientAge BETWEEN 18 AND 65 THEN '18-65'  
        ELSE 'Over 65'  
    END AS [Age Group]
FROM dimPatient dimP  
ORDER BY dimP.PatientAge;