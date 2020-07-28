/*
  Delete from the dbo.Orders table orders placed by customers from 
  Brazil.
*/

USE TSQLV4

DELETE O
FROM dbo.Orders AS O
    INNER JOIN dbo.Customers AS C
    ON C.custid = O.custid
WHERE C.country = 'Brazil'
