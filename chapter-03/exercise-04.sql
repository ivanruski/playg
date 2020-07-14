-- Return customers and their orders, including customers who placed no
-- orders.

USE TSQLV4

SELECT c.custid,
       c.companyname,
       o.orderid,
       o.orderdate
FROM Sales.Customers AS c
    LEFT OUTER JOIN Sales.Orders AS o
    ON c.custid = o.custid