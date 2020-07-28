-- Write a query against the Sales.OrderDetails table that returns orders
-- with total value (quantity * unitprice) greater than 10 000 and 
-- sorted by total value

USE TSQLV4

SELECT orderid,
       SUM((qty * unitprice)) as totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM((qty * unitprice)) > 10000
ORDER BY totalvalue