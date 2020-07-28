-- Write a query against the Sales.Orders table that returns
-- order placed at the end of the month

USE TSQLV4

SELECT orderid,
       orderdate,
       custid,
       empid
FROM Sales.Orders
-- Solution from the book
WHERE orderdate = EOMONTH(orderdate)
-- My over complicated solution - still right though :)
-- WHERE DATEPART(dd,EOMONTH(orderdate)) = DATEPART(dd, orderdate)