-- Write a query that returns employees who did not place orders on or
-- after May 1, 2016: 

USE TSQLV4

SELECT empid, firstname, lastname
FROM Hr.Employees AS E
WHERE NOT EXISTS(
    SELECT O.empid
    FROM Sales.Orders AS O
    WHERE O.orderdate >= '20160501' AND
          E.empid = O.empid)

-- The solution from the book is pretty good because the subquery can be
-- executed only once instead for every row

SELECT empid, FirstName, lastname
FROM HR.Employees
WHERE empid NOT IN
  (SELECT O.empid
   FROM Sales.Orders AS O
   WHERE O.orderdate >= '20160501');
