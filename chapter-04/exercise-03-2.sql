/*
  Write a query that returns rows with row numbers 11 through 20 based on the row-number definition in Exercise 3-1. Use a CTE to encapsulate the code from Exercise 3-1:
*/

USE TSQLV4;

WITH Orders_with_rownums
AS
(
    SELECT O.orderid,
       O.orderdate,
       O.custid,
       O.empid,
       ROW_NUMBER() OVER(ORDER BY O.orderdate, O.orderid) AS rownum
    FROM Sales.Orders AS O
)
SELECT orderid,
       orderdate,
       custid,
       empid,
       rownum
FROM Orders_with_rownums
WHERE rownum > 10 AND rownum < 21

-- Good note from the book:
/*
  You might wonder why you need a table expression here. Window functions (such as the ROW_NUMBER function) are allowed only in the SELECT and ORDER BY clauses of a query, and not directly in the WHERE clause. By using a table expression, you can invoke the ROW_NUMBER function in the SELECT clause, assign an alias to the result column, and refer to that alias in the WHERE clause of the outer query.
*/