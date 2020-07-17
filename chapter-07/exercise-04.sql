/*
  Write a query against the dbo.Orders table that returns a row for each employee, a column for each order year, and the count of orders for each employee and order year:
*/

USE TSQLV4

-- Using PIVOT

SELECT empid,
      [2014] AS cnt2014,
      [2015] AS cnt2015,
      [2016] AS cnt2016
FROM (
        SELECT empid, YEAR(orderdate) AS orderyear, orderid
        FROM dbo.Orders
    ) AS O
    PIVOT (
        COUNT(orderid)
        FOR 
        orderyear IN ([2014], [2015], [2016])
    ) AS P

-- Using standard SQL

SELECT empid,
       cnt2014 = COUNT(CASE orderyear WHEN 2014 THEN orderid END),
       cnt2015 = COUNT(CASE orderyear WHEN 2015 THEN orderid END),
       cnt2016 = COUNT(CASE orderyear WHEN 2016 THEN orderid END)
FROM (
        SELECT empid,
               orderid,
               YEAR(orderdate) AS orderyear
        FROM dbo.Orders
    ) AS O
GROUP BY empid