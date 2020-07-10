-- Write a query that returns a row for each employee and day in the
-- range June 12, 2016 through June 16, 2016:

USE TSQLV4

SELECT e.empid,
       CAST(DATEADD(day, nums.n, '20160611') AS date) AS dt
FROM Hr.Employees as e
    CROSS JOIN dbo.Nums as nums
WHERE nums.n <= DATEDIFF(DAY, '20160211', '20160216')
ORDER BY e.empid