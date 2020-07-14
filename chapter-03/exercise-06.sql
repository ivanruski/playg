-- Return customers with orders placed on Feb 12, 2016, along with their  -- orders

USE TSQLV4

SELECT c.custid,
       c.companyname,
       o.orderid,
       o.orderdate
FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
    ON c.custid = o.custid 
    AND o.orderdate = '20160212';
