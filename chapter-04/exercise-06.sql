-- Write a query that returns customers who placed orders in 2015 but not
-- in 2016:

USE TSQLV4

SELECT C.custid,
       C.companyname
FROM Sales.Customers AS C
WHERE NOT EXISTS (
    SELECT *
    FROM Sales.Orders AS O
    WHERE O.orderdate >= '20160101' AND
          O.orderdate <= '20161231' AND
          O.custid = C.custid)
    AND
    EXISTS (
       SELECT *
       FROM Sales.Orders AS O
       WHERE O.orderdate >= '20150101' AND
             O.orderdate <= '20151231' AND
             O.custid = C.custid)
    