/*
  Write a query that returns customer and employee pairs that had order activity in both January 2016 and February 2016:
*/

USE TSQLV4

SELECT O.custid, O.empid
FROM Sales.Orders AS O
WHERE YEAR(O.orderdate) = 2016 AND
      MONTH(O.orderdate) = 1

INTERSECT

SELECT O.custid, O.empid
FROM Sales.Orders AS O
WHERE YEAR(O.orderdate) = 2016 AND
      MONTH(O.orderdate) = 2