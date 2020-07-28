/*
  Use a SELECT INTO statement to create and populate the dbo.Orders table
  with orders from the Sales.Orders table that were placed in the years
  2014 through 2016.
*/

USE TSQLV4

DROP TABLE IF EXISTS dbo.Orders

SELECT orderid,
       custid,
       empid,
       orderdate,
       requireddate,
       shippeddate,
       shipperid,
       freight,
       shipname,
       shipaddress,
       shipcity,
       shipregion,
       shippostalcode,
       shipcountry
INTO dbo.Orders
FROM Sales.Orders
WHERE orderdate >= '2014-01-01' AND
      orderdate <= '2016-12-31'