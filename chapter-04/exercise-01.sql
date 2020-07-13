/*
  The following query attempts to filter orders that were not placed on the last day of the year. It’s supposed to return the order ID, order date, customer ID, employee ID, and respective end-of-year date for each order:
*/

-- USE TSQLV4
-- 
-- SELECT orderid, orderdate, custid, empid,
--   DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
-- FROM Sales.Orders
-- WHERE orderdate <> endofyear;

/*
  When you try to run this query, you get the following error: 
  
  Click here to view code image Msg 207, Level 16, State 1, Line 233
  Invalid column name 'endofyear'.
  
  Explain what the problem is, and suggest a valid solution.
*/

/* 
  The problem is that WHERE is executed before SELECT, which means that there is no such column as 'endofyear' when WHERE is executed.

  One way to solve this problem is to copy the expression on left side of the '<copy_this> AS endofyear'.
  Another way is use a derived table, CTE, view or inline table-valued function.
*/

USE TSQLV4

SELECT orderid, orderdate, custid, empid,
  DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
FROM Sales.Orders
WHERE orderdate <> DATEFROMPARTS(YEAR(orderdate), 12, 31);

-- OR 

USE TSQLV4

GO

WITH ORDERS_WITH_EOF
AS
(
    SELECT orderid, orderdate, custid, empid,
      DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
    FROM Sales.Orders
)
SELECT *
FROM ORDERS_WITH_EOF
WHERE orderdate <> endofyear;

