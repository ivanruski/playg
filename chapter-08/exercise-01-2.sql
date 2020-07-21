/*
  Insert into the dbo.Customers table all customers from Sales.Customers 
  who placed orders.
*/

USE TSQLV4

INSERT INTO dbo.Customers (custid, companyname, country, region, city)
SELECT C.custid, C.companyname, C.country, C.region, C.city
FROM Sales.Customers AS C
WHERE C.custid IN 
    (
        SELECT DISTINCT custid
        FROM Sales.Orders
    )