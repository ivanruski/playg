/*
  Write a query that returns the maximum value in the orderdate column for each employee:
*/

USE TSQLV4

SELECT empid,
       MAX(orderdate) AS maxorderdate
FROM Sales.Orders
GROUP BY empid