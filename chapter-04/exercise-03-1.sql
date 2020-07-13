/*
  Write a query that calculates a row number for each order based on orderdate, orderid ordering:
*/

USE TSQLV4

SELECT O.orderid,
       O.orderdate,
       O.custid,
       O.empid,
       ROW_NUMBER() OVER(ORDER BY O.orderdate, O.orderid) AS rownum
FROM Sales.Orders AS O