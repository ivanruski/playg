-- Write a query that returns all orders placed by the customer(s) who
-- placed the highest numbers of orders.
-- Note that more than one customer could have the highest number of
-- orders.

USE TSQLV4

SELECT O1.custid,
       O1.orderid,
       O1.orderdate,
       O1.empid
FROM Sales.Orders AS O1
WHERE (
    SELECT COUNT(orderid) AS numorders
    FROM Sales.Orders AS O2
    GROUP BY O2.custid
    ORDER BY numorders DESC
    -- ORDER BY is the only phase processed after SELECT
    OFFSET 0 ROWS FETCH FIRST 1 ROW ONLY
    ) = (
    SELECT COUNT(O3.orderid)
    FROM Sales.Orders AS O3
    WHERE O3.custid = O1.custid
    )

-- The solution from the book is pretty good

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid IN
  (SELECT TOP (1) WITH TIES O.custid
   FROM Sales.Orders AS O
   GROUP BY O.custid
   ORDER BY COUNT(*) DESC);

