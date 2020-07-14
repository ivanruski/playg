-- Write a query that returns all customers in the output, but matches
-- them with their respective orders only if they were placed on
-- February 12, 2016

USE TSQLV4

SELECT c.custid,
       c.companyname,
       o.orderid,
       o.orderdate
FROM Sales.Customers AS c
    LEFT OUTER JOIN (
        SELECT orderid,
               orderdate,
               custid
        FROM Sales.Orders
        WHERE orderdate = '20160212') AS o
    ON c.custid = o.custid

-- or 

SELECT c.custid,
       c.companyname,
       o.orderid,
       o.orderdate
FROM Sales.Customers AS c
    LEFT OUTER JOIN Sales.Orders AS o
    ON c.custid = o.custid
    AND o.orderdate = '20160212'