-- Write a query against the Sales.Orders table that returns 
-- orderers placed in June 2015

USE TSQLV4

-- The easiest way, however using MONTH and YEAR doesn't take advantage of indexing
SELECT orderid,
       orderdate,
       custid,
       empid
FROM Sales.Orders
WHERE MONTH(orderdate) = 6 and
      YEAR(orderdate) = 2015

SELECT orderid,
       orderdate,
       custid,
       empid
FROM Sales.Orders
WHERE orderdate >= '2015-06-01' and
      orderdate <= '2015-06-30'