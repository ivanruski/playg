-- Return all customers, and for each return a Yes/No value depending on -- whether the customer placed orders on February 12, 2016:

USE TSQLV4

-- Use DISTINCT because if there is a customer who placed 2 orders
-- on the filtered date, it will show up 2 times in the result set
SELECT DISTINCT c.custid, c.companyname,
       CASE o.orderdate
           WHEN '20160212' THEN 'Yes'
           ELSE 'No'
       END AS HasOrderOn20160212
FROM Sales.Customers AS c
    LEFT OUTER JOIN Sales.Orders AS o
    ON c.custid = o.custid
    AND o.orderdate = '20160212'