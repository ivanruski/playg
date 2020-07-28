-- Run the following code to create and populate the EmpYearOrders table:

USE TSQLV4;

-- DROP TABLE IF EXISTS dbo.EmpYearOrders;
-- 
-- CREATE TABLE dbo.EmpYearOrders
-- (
--   empid INT NOT NULL CONSTRAINT PK_EmpYearOrders PRIMARY KEY,
--   cnt2014 INT NULL,
--   cnt2015 INT NULL,
--   cnt2016 INT NULL
-- );
-- 
-- INSERT INTO dbo.EmpYearOrders(empid, cnt2014, cnt2015, cnt2016)
-- SELECT empid,
--        [2014] AS cnt2014,
--        [2015] AS cnt2015,
--        [2016] AS cnt2016
-- FROM (
--         SELECT empid, YEAR(orderdate) AS orderyear
--         FROM dbo.Orders
--     ) AS D
--     PIVOT(
--         COUNT(orderyear)
--         FOR orderyear IN([2014], [2015], [2016])
--     ) AS P;
 
/*
  Write a query against the EmpYearOrders table that unpivots the data, returning a row for each employee and order year with the number of orders. Exclude rows in which the number of orders is 0 (in this example, employee 3 in the year 2015).
*/

-- USING UNPIVOT

SELECT empid,
       orderyear,
       numorders
FROM (
        SELECT empid,
               cnt2014 AS [2014],
               cnt2015 AS [2015],
               cnt2016 AS [2016]
        FROM dbo.EmpYearOrders
    ) AS E
    UNPIVOT (
        numorders FOR
        orderyear IN ([2014], [2015], [2016])
    ) AS U
WHERE numorders > 0

-- USING standard SQL

SELECT empid,
       orderyear,
       numorders
FROM (
        SELECT empid,
               cnt2014,
               cnt2015,
               cnt2016
        FROM dbo.EmpYearOrders
    ) AS E
    CROSS APPLY (
        VALUES('2014', cnt2014),
              ('2015', cnt2015),
              ('2016', cnt2016) 
    ) AS UNP(orderyear, numorders)
WHERE numorders <> 0


