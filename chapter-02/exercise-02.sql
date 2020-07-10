-- Explain what's wrong in the following query, and provide a correct
-- alternative:

USE TSQLV4

-- SELECT Customers.custid,
--        Customers.companyname,
--        Orders.orderdate
-- FROM Sales.Customers AS C
--   INNER JOIN Sales.Orders AS O
--      ON Customers.custid = Orders.custid;

-- The problem with the query above is that the tables Customers and
-- Orders are given aliases C and O, but we are trying to access columns
-- from then using the full names.
-- The query will work if we give an aliases Customers and Orders or 
-- remove them at all, or use C and O instead of Customer. and Orders.

SELECT Customers.custid,
       Customers.companyname,
       Orders.orderdate
FROM Sales.Customers
  INNER JOIN Sales.Orders
     ON Customers.custid = Orders.custid;