/*
  Write a query that returns customer and employee pairs that had order activity in January 2016 but not in February 2016:
*/

USE TSQLV4

SELECT O.custid, O.empid
FROM Sales.Orders AS O
WHERE YEAR(O.orderdate) = 2016 AND
      MONTH(O.orderdate) = 1

EXCEPT

SELECT O.custid, O.empid
FROM Sales.Orders AS O
WHERE YEAR(O.orderdate) = 2016 AND
      MONTH(O.orderdate) = 2