-- Write a query that generates five copies of each employee row

USE TSQLV4

SELECT e1.empid,
       e1.firstname,
       e1.lastname,
       nums.n
FROM HR.Employees AS e1
CROSS JOIN (SELECT n FROM dbo.Nums WHERE n < 6) as nums
ORDER BY n, empid