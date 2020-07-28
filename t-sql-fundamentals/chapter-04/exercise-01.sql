-- Write a query that returns all orders placed on the last day of
-- activity that can be found in the Orders table:

USE TSQLV4

SELECT O1.orderid,
       O1.orderdate,
       O1.custid,
       O1.empid
FROM Sales.Orders AS O1
WHERE O1.orderdate = (
    SELECT MAX(O2.orderdate)
    FROM Sales.Orders AS O2)