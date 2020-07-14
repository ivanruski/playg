/*
  Encapsulate the query from Exercise 2-1 in a derived table. Write a join query between the derived table and the Orders table to return the orders with the maximum order date for each employee:
*/

USE TSQLV4

SELECT O1.empid,
       O1.orderid,
       O1.orderdate,
       O1.custid
FROM Sales.Orders AS O1
    INNER JOIN (
        SELECT O.empid,
               MAX(O.orderdate) AS maxorderdate
        FROM Sales.Orders AS O
        GROUP BY O.empid
    ) AS O
    ON O1.empid = O.empid AND
       O1.orderdate = O.maxorderdate