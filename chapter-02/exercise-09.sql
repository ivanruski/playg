-- Using HR.Employees table, write SELECT statement that returns for each
-- employee the gender based on the title of courtesy. For 'Ms.' and 
-- 'Mrs' return 'Female'; for 'Mr' return 'Male' and in all other cases
-- return 'Unknown'

USE TSQLV4

SELECT empid
    ,firstname
    ,lastname
    ,titleofcourtesy
    ,CASE titleofcourtesy
        WHEN 'Ms.' THEN 'Female'
        WHEN 'Mrs.' THEN 'Female'
        WHEN 'Mr.' THEN 'Male'
        ELSE 'Unknown'
    END AS gender
FROM HR.Employees