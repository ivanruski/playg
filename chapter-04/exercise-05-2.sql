/*
  Write a query against Sales.VEmpOrders that returns the running total quantity for each employee and year:
*/

USE TSQLV4

SELECT V.empid,
       V.orderyear,
       V.qty,
       (
           SELECT SUM(V1.qty)
           FROM Sales.VEmpOrders AS V1
           WHERE V1.empid = V.empid AND
                 V1.orderyear <= V.orderyear
       ) AS runqty
FROM Sales.VEmpOrders AS V
ORDER BY V.empid, V.orderyear