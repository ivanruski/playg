-- Return customers who placed no orders

USE TSQLV4

SELECT c.custid,
       c.companyname
FROM Sales.Customers AS c
    LEFT OUTER JOIN Sales.Orders AS o
    ON c.custid = o.custid
WHERE o.orderid IS NULL
