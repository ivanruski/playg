/*
  Update all orders in the dbo.Orders table that were placed by United
  Kingdom customers, and set their shipcountry, shipregion, and shipcity
  values to the country, region, and city values of the corresponding
  customers.
*/

USE TSQLV4

UPDATE O
SET
    O.shipcountry = C.country,
    O.shipregion = C.region,
    O.shipcity = C.city
FROM dbo.Orders AS O
    INNER JOIN dbo.Customers AS C
    ON C.custid = O.custid
WHERE C.country = 'UK'